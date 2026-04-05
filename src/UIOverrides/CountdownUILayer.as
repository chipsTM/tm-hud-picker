// Countdown Layer override to support custom styles
class CountdownUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultCountdownPosition = vec2(155.0, 4.0);
    vec2 CountdownPosition = DefaultCountdownPosition;

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

}