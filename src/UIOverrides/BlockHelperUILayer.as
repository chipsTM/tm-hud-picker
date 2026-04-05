// Block Helper Layer override to support custom styles
class BlockHelperUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultBlockHelperPosition = vec2(0.0, 50.0);
    vec2 BlockHelperPosition = DefaultBlockHelperPosition;

    BlockHelperUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    BlockHelperUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ blockhelper_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_BlockHelper"));
        if (blockhelper_frame is null) return;

        blockhelper_frame.RelativePosition_V3 = DefaultBlockHelperPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ blockhelper_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_BlockHelper"));
        if (blockhelper_frame is null) return;

        blockhelper_frame.RelativePosition_V3 = BlockHelperPosition;
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", BlockHelperPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", BlockHelperPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        BlockHelperPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            BlockHelperPosition = DefaultBlockHelperPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("blockhelper_position") && styleSettings["blockhelper_position"].GetType() != Json::Type::Null) {
            BlockHelperPosition = vec2(styleSettings["blockhelper_position"][0], styleSettings["blockhelper_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["blockhelper_position"] = Json::Array();
        styleSettingsObj["blockhelper_position"].Add(BlockHelperPosition.x);
        styleSettingsObj["blockhelper_position"].Add(BlockHelperPosition.y);
        return styleSettingsObj;
    }

}