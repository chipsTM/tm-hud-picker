// Records Layer override to support custom styles
class RecordsUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultRecordsPosition = vec2(-160.0, 30.0);
    vec2 RecordsPosition = DefaultRecordsPosition;
    vec2 RecordsSize;

    RecordsUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    RecordsUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ records_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Record"));
        if (records_frame is null) return;

        records_frame.RelativePosition_V3 = DefaultRecordsPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ records_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Record"));
        if (records_frame is null) return;

        records_frame.RelativePosition_V3 = RecordsPosition;

        // CGameManialinkFrame@ sub_records_frame = cast<CGameManialinkFrame@>(records_frame.GetFirstChild("frame-records"));
        // if (sub_records_frame is null) return;
        RecordsSize = vec2(50, 70);
        // RecordsSize = vec2(60, 180);
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", RecordsPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", RecordsPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        RecordsPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            RecordsPosition = DefaultRecordsPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("records_position") && styleSettings["records_position"].GetType() != Json::Type::Null) {
            RecordsPosition = vec2(styleSettings["records_position"][0], styleSettings["records_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["records_position"] = Json::Array();
        styleSettingsObj["records_position"].Add(RecordsPosition.x);
        styleSettingsObj["records_position"].Add(RecordsPosition.y);
        return styleSettingsObj;
    }

    void Locator(vec2 oldMouse) override {
        if (IsDotPressed) {
            vec2 newMouse = UI::GetMousePos();
            vec4 calcSize = MLRectToScreen(RecordsPosition, RecordsSize, HAlign::Left, VAlign::Top);
            DrawBounds(calcSize, DisplayName);
            if (InBounds(calcSize, newMouse)) HighlightBounds(calcSize);
            IsDragging = GetDragState(calcSize, newMouse, IsDragging);
            if (IsDragging && oldMouse != newMouse) {
                RecordsPosition.x += (newMouse.x - oldMouse.x) / xScale;
                RecordsPosition.y -= (newMouse.y - oldMouse.y) / yScale;
                RecordsPosition = ClampBounds(RecordsPosition, RecordsSize, HAlign::Left, VAlign::Top);
            }
            if (InBounds(calcSize, newMouse) && UI::IsMouseDoubleClicked(UI::MouseButton::Right)) {
                RecordsPosition = DefaultRecordsPosition;
            }
        }
    }

}