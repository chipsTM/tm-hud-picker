bool resetSwitch = false;

[Setting hidden]
bool toggleInterface = false;

[SettingsTab name="HUD Tree" icon="Kenney::Car"]
void RenderHUDTreeSettings() {
    toggleInterface = UI::Checkbox("Show HUD when Openplanet Interface is shown", toggleInterface);
    UI::TextWrapped("DISCLAIMER: You are responsible for ensuring you re-enable any hidden elements. Otherwise disabling the plugin should re-enable all elements");
    if (gameInfo.IsPlaying()) {
        if (UI::TreeNode("Race", UI::TreeNodeFlags::Framed)) {
            for (uint i = 0; i < uiDic["Race"].Length; i++) {
                DrawTree(uiDic["Race"][i]);
            }
            UI::TreePop();
        }
        if (UI::TreeNode("Knockout", UI::TreeNodeFlags::Framed)) {
            for (uint i = 0; i < uiDic["Knockout"].Length; i++) {
                DrawTree(uiDic["Knockout"][i]);
            }
            UI::TreePop();
        }
    } else {
        UI::TextWrapped("\\$FF0You need to be in a valid playground to change these settings\\$z");
    }
    if (UI::TreeNode("Reset Settings Here", UI::TreeNodeFlags::Framed)) {
        bool switchActive = UI::Checkbox("Click here first to reset", resetSwitch);
        if (switchActive) {
            resetSwitch = true;
            UI::SameLine();
            if (UI::Button("Reset")) {
                uiDic = Json::Parse(elementsJson);
                // uiDic = Json::FromFile("src/elements.json");
                ResetIndexes("Race");
                ResetIndexes("Knockout");
                resetSwitch = false;
            }
        } else {
            resetSwitch = false;
        }
        UI::TreePop();
    }
}

void DrawTree(Json::Value@ setting) {
    if (UI::TreeNode(string(setting["displayName"]) + ((bool(setting["visibility"])) ? " \\$0F0" + Icons::Eye + "\\$z" : " \\$F00" + Icons::EyeSlash + "\\$z") + " \\$aaa" + string(setting["description"]) + "\\$z###" + string(setting["controlId"]) , UI::TreeNodeFlags::Framed)) {
        string buttonText = (bool(setting["visibility"])) ? "Hide" : "Show";
        bool clicked = UI::Button(buttonText);

        if (clicked) {
            setting["changed"] = true;
            setting["visibility"] = !bool(setting["visibility"]);
        }

        if (setting.HasKey("styles")) {
            if (string(setting["controlId"]) == "Race_Chrono") ChronoStylesSettings(setting);
        }

        if (setting["children"].Length > 0 && bool(setting["visibility"])) {
            for (uint i = 0; i < setting["children"].Length; i++) {
                DrawTree(setting["children"][i]);
            }
        }
        UI::TreePop();
    }
}