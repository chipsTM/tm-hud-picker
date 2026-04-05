// Block Helper Layer override to support custom styles
class RespawnHelperUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultRespawnHelperPosition = vec2(160.0, 9.0);
    vec2 RespawnHelperPosition = DefaultRespawnHelperPosition;

    RespawnHelperUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    RespawnHelperUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ respawnhelper_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_RespawnHelper"));
        if (respawnhelper_frame is null) return;

        respawnhelper_frame.RelativePosition_V3 = DefaultRespawnHelperPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ respawnhelper_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_RespawnHelper"));
        if (respawnhelper_frame is null) return;

        respawnhelper_frame.RelativePosition_V3 = RespawnHelperPosition;
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", RespawnHelperPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", RespawnHelperPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        RespawnHelperPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            RespawnHelperPosition = DefaultRespawnHelperPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("respawnhelper_position") && styleSettings["respawnhelper_position"].GetType() != Json::Type::Null) {
            RespawnHelperPosition = vec2(styleSettings["respawnhelper_position"][0], styleSettings["respawnhelper_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["respawnhelper_position"] = Json::Array();
        styleSettingsObj["respawnhelper_position"].Add(RespawnHelperPosition.x);
        styleSettingsObj["respawnhelper_position"].Add(RespawnHelperPosition.y);
        return styleSettingsObj;
    }

}