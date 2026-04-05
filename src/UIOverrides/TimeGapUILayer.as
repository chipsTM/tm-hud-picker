// Time Gap Layer override to support custom styles
class TimeGapUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultTimeGapPosition = vec2(44.0, -52.0);
    vec2 TimeGapPosition = DefaultTimeGapPosition;

    TimeGapUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    TimeGapUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ timegap_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_TimeGap"));
        if (timegap_frame is null) return;

        timegap_frame.RelativePosition_V3 = DefaultTimeGapPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ timegap_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_TimeGap"));
        if (timegap_frame is null) return;

        timegap_frame.RelativePosition_V3 = TimeGapPosition;
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", TimeGapPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", TimeGapPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        TimeGapPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            TimeGapPosition = DefaultTimeGapPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("timegap_position") && styleSettings["timegap_position"].GetType() != Json::Type::Null) {
            TimeGapPosition = vec2(styleSettings["timegap_position"][0], styleSettings["timegap_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["timegap_position"] = Json::Array();
        styleSettingsObj["timegap_position"].Add(TimeGapPosition.x);
        styleSettingsObj["timegap_position"].Add(TimeGapPosition.y);
        return styleSettingsObj;
    }

}