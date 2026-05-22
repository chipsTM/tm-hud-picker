// Countdown Layer override to support custom styles
class CountdownUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultCountdownPosition = vec2(155.0, 4.0);
    vec2 CountdownPosition = DefaultCountdownPosition;
    vec2 CountdownSize;

    CountdownUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    CountdownUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ countdown_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Countdown"));
        if (countdown_frame is null) return;

        countdown_frame.RelativePosition_V3 = DefaultCountdownPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ countdown_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Countdown"));
        if (countdown_frame is null) return;

        countdown_frame.RelativePosition_V3 = CountdownPosition;

        CGameManialinkLabel@ sub_countdown_frame = cast<CGameManialinkLabel@>(countdown_frame.GetFirstChild("label-countdown"));
        if (sub_countdown_frame is null) return;
        CountdownSize = sub_countdown_frame.Size;
        CountdownSize.y = 8;
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", CountdownPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", CountdownPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        CountdownPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            CountdownPosition = DefaultCountdownPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("countdown_position") && styleSettings["countdown_position"].GetType() != Json::Type::Null) {
            CountdownPosition = vec2(styleSettings["countdown_position"][0], styleSettings["countdown_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["countdown_position"] = Json::Array();
        styleSettingsObj["countdown_position"].Add(CountdownPosition.x);
        styleSettingsObj["countdown_position"].Add(CountdownPosition.y);
        return styleSettingsObj;
    }

    void Locator(vec2 oldMouse) override {
        if (IsDotPressed) {
            vec2 newMouse = UI::GetMousePos();
            vec4 calcSize = MLRectToScreen(CountdownPosition, CountdownSize, HAlign::Right, VAlign::Top);
            DrawBounds(calcSize, DisplayName);
            if (InBounds(calcSize, newMouse)) HighlightBounds(calcSize);
            IsDragging = GetDragState(calcSize, newMouse, IsDragging);
            if (IsDragging && oldMouse != newMouse) {
                CountdownPosition.x += (newMouse.x - oldMouse.x) / xScale;
                CountdownPosition.y -= (newMouse.y - oldMouse.y) / yScale;
                CountdownPosition = ClampBounds(CountdownPosition, CountdownSize, HAlign::Right, VAlign::Top);
            }
            if (InBounds(calcSize, newMouse) && UI::IsMouseDoubleClicked(UI::MouseButton::Right)) {
                CountdownPosition = DefaultCountdownPosition;
            }
        }
    }

}