// Block Helper Layer override to support custom styles
class RespawnHelperUILayer : UILayerWrapper {
    // these should be the defaults when plugin is disabled
    vec2 DefaultRespawnHelperPosition = vec2(160.0, 9.0);
    vec2 RespawnHelperPosition = DefaultRespawnHelperPosition;
    vec2 RespawnHelperSize;

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

        CGameManialinkFrame@ sub_respawnhelper_frame = cast<CGameManialinkFrame@>(respawnhelper_frame.GetFirstChild("frame-helper"));
        if (sub_respawnhelper_frame is null) return;
        RespawnHelperSize = sub_respawnhelper_frame.Size;
        RespawnHelperSize.y = 23;
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

    void Locator(vec2 oldMouse) override {
        if (IsDotPressed) {
            vec2 newMouse = UI::GetMousePos();
            vec4 calcSize = MLRectToScreen(RespawnHelperPosition, RespawnHelperSize, HAlign::Right, VAlign::Bottom);
            DrawBounds(calcSize, DisplayName);
            if (InBounds(calcSize, newMouse)) HighlightBounds(calcSize);
            IsDragging = GetDragState(calcSize, newMouse, IsDragging);
            if (IsDragging && oldMouse != newMouse) {
                RespawnHelperPosition.x += (newMouse.x - oldMouse.x) / xScale;
                RespawnHelperPosition.y -= (newMouse.y - oldMouse.y) / yScale;
                RespawnHelperPosition = ClampBounds(RespawnHelperPosition, RespawnHelperSize, HAlign::Right, VAlign::Bottom);
            }
            if (InBounds(calcSize, newMouse) && UI::IsMouseDoubleClicked(UI::MouseButton::Right)) {
                RespawnHelperPosition = DefaultRespawnHelperPosition;
            }
        }
    }

}