// Checkpoint Layer override to support custom styles
class CheckpointUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultCheckpointPosition = vec2(-10.0, 45.0);
    vec2 CheckpointPosition = DefaultCheckpointPosition;
    vec2 CheckpointSize;

    CheckpointUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    CheckpointUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ checkpoint_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Checkpoint"));
        if (checkpoint_frame is null) return;

        checkpoint_frame.RelativePosition_V3 = DefaultCheckpointPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ checkpoint_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Checkpoint"));
        if (checkpoint_frame is null) return;

        checkpoint_frame.RelativePosition_V3 = CheckpointPosition;
        CheckpointSize = vec2(28, 39);
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", CheckpointPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", CheckpointPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        CheckpointPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            CheckpointPosition = DefaultCheckpointPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("checkpoint_position") && styleSettings["checkpoint_position"].GetType() != Json::Type::Null) {
            CheckpointPosition = vec2(styleSettings["checkpoint_position"][0], styleSettings["checkpoint_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["checkpoint_position"] = Json::Array();
        styleSettingsObj["checkpoint_position"].Add(CheckpointPosition.x);
        styleSettingsObj["checkpoint_position"].Add(CheckpointPosition.y);
        return styleSettingsObj;
    }

    void Locator(vec2 oldMouse) override {
        if (IsDotPressed) {
            vec2 newMouse = UI::GetMousePos();
            CheckpointPosition = vec2(CheckpointPosition.x - 10, CheckpointPosition.y + 21);
            vec4 calcSize = MLRectToScreen(CheckpointPosition, CheckpointSize, HAlign::Left, VAlign::Top);
            DrawBounds(calcSize, "Checkpoint");
            if (InBounds(calcSize, newMouse)) HighlightBounds(calcSize);
            IsDragging = GetDragState(calcSize, newMouse, IsDragging);
            if (IsDragging && oldMouse != newMouse) {
                CheckpointPosition.x += (newMouse.x - oldMouse.x) / xScale;
                CheckpointPosition.y -= (newMouse.y - oldMouse.y) / yScale;
                CheckpointPosition = ClampBounds(CheckpointPosition, CheckpointSize, HAlign::Left, VAlign::Top);
            }
            CheckpointPosition = vec2(CheckpointPosition.x + 10, CheckpointPosition.y - 21);
            if (InBounds(calcSize, newMouse) && UI::IsMouseDoubleClicked(UI::MouseButton::Right)) {
                CheckpointPosition = DefaultCheckpointPosition;
            }
        }
    }

}