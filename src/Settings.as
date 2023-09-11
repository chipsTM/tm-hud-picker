[Setting hidden]
string SerializedData;

bool resetSwitch = false;

[SettingsTab name="HUD Tree" icon="Kenney::Car"]
void RenderHUDTreeSettings() {
    UI::Text("DISCLAIMER: You are responsible for ensuring you re-enable any hidden elements");
    // if (UI::Button("Save Settings")) {
    //     print("saving settings");
    //     auto curSettings = plugin.GetSetting("SerializedData");
    //     curSettings.WriteString(Json::Write(uiDic));
    // }
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
        UI::Text("You need to be in a valid playground to change these settings");
    }
    bool switchActive = UI::Checkbox("Click here first to reset", resetSwitch);
    if (switchActive) {
        resetSwitch = true;
        UI::SameLine();
        if (UI::Button("Reset")) {
            uiDic = Json::FromFile("src/elements.json");
            ResetIndexes("Race");
            ResetIndexes("Knockout");
            resetSwitch = false;
        }
    } else {
        resetSwitch = false;
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
            auto styleKeys = setting["styles"].GetKeys();
            // vec3 curColor;
            for (uint i = 0; i < styleKeys.Length; i++) {
                auto val = setting["styles"][styleKeys[i]];
                vec3 curColor = vec3(val[0], val[1], val[2]);
                vec3 newColor = UI::InputColor3("Text Color", curColor);
                if (curColor != newColor) {
                    setting["styles"][styleKeys[i]][0] = newColor.x;
                    setting["styles"][styleKeys[i]][1] = newColor.y;
                    setting["styles"][styleKeys[i]][2] = newColor.z;
                }
            }
        }

        if (setting["children"].Length > 0 && bool(setting["visibility"])) {
            for (uint i = 0; i < setting["children"].Length; i++) {
                DrawTree(setting["children"][i]);
            }
        }
        UI::TreePop();
    }
}