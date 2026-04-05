// BestRaceViewer Layer override to support custom styles
class BestRaceViewerUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultBestRaceViewerPosition = vec2(135.0, -10.0);
    vec2 BestRaceViewerPosition = DefaultBestRaceViewerPosition;

    BestRaceViewerUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    BestRaceViewerUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ bestraceviewer_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_BestRaceViewer"));
        if (bestraceviewer_frame is null) return;

        bestraceviewer_frame.RelativePosition_V3 = DefaultBestRaceViewerPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ bestraceviewer_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_BestRaceViewer"));
        if (bestraceviewer_frame is null) return;

        bestraceviewer_frame.RelativePosition_V3 = BestRaceViewerPosition;
    }

    void RenderStyleSettings() override {
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", BestRaceViewerPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", BestRaceViewerPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        BestRaceViewerPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            BestRaceViewerPosition = DefaultBestRaceViewerPosition;
        }
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        if (styleSettings.HasKey("bestraceviewer_position") && styleSettings["bestraceviewer_position"].GetType() != Json::Type::Null) {
            BestRaceViewerPosition = vec2(styleSettings["bestraceviewer_position"][0], styleSettings["bestraceviewer_position"][1]);
        }
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["bestraceviewer_position"] = Json::Array();
        styleSettingsObj["bestraceviewer_position"].Add(BestRaceViewerPosition.x);
        styleSettingsObj["bestraceviewer_position"].Add(BestRaceViewerPosition.y);
        return styleSettingsObj;
    }

}