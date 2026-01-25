bool resetSwitch = false;

[Setting hidden]
bool toggleOverlay = false;

[SettingsTab name="HUD Tree" icon="Kenney::Car"]
void RenderHUDTreeSettings() {
    toggleOverlay = UI::Checkbox("Disable HUD Picker when Openplanet overlay is open", toggleOverlay);
    UI::Text("");
    UI::TextWrapped("DISCLAIMER: You are responsible for ensuring you re-enable any hidden elements. Otherwise disabling the plugin should re-enable all elements");
    if (gameInfo.IsPlaying()) {
        if (UI::TreeNode("Race", UI::TreeNodeFlags::Framed)) {
            for (uint i = 0; i < Race.Length; i++) {
                DrawTree(Race[i]);
            }
            UI::TreePop();
        }
        if (UI::TreeNode("Knockout", UI::TreeNodeFlags::Framed)) {
            for (uint i = 0; i < Knockout.Length; i++) {
                DrawTree(Knockout[i]);
            }
            UI::TreePop();
        }
        if (UI::TreeNode("COTD", UI::TreeNodeFlags::Framed)) {
            for (uint i = 0; i < COTD.Length; i++) {
                DrawTree(COTD[i]);
            }
            UI::TreePop();
        }
    } else {
        UI::TextWrapped("\\$FF0You need to be in a valid playground to change these settings\\$z");
    }
}

void DrawTree(UILayerWrapper@ element) {
    if (UI::TreeNode(element.DisplayName + ((element.Visibility) ? " \\$0F0" + Icons::Eye + "\\$z" : " \\$F00" + Icons::EyeSlash + "\\$z") + " \\$aaa" + element.Description + "\\$z###" + element.ControlId , UI::TreeNodeFlags::Framed)) {
        string buttonText = (element.Visibility) ? "Hide" : "Show";
        if (UI::Button(buttonText)) {
            element.Changed = true;
            element.Visibility = !element.Visibility;
        }
        if (!element.DefaultVisibility) {
            UI::SameLine();
            UI::Text("\\$F60Hidden by server\\$z");
        }

        element.RenderStyleSettings();

        if (element.SubElements.Length > 0 && element.Visibility) {
            for (uint i = 0; i < element.SubElements.Length; i++) {
                DrawTree(element.SubElements[i]);
            }
        }
        UI::TreePop();
    }
}

auto settingFileName = "settings_v4.json";
void LoadState() {
    if (IO::FileExists(IO::FromStorageFolder(settingFileName))) {
        auto curSettings = Json::FromFile(IO::FromStorageFolder(settingFileName));
        if (curSettings.GetType() == Json::Type::Null) {
            // settings don't exist so ignore
            // use defaults until next/change and save
        } else {
            for (uint i = 0; i < Categories.Length; i++) {
                for (uint j = 0; j < Categories[i].Length; j++) {
                    Categories[i][j].Visibility = curSettings[Categories[i][j].ControlId];
                    Categories[i][j].Changed = true;
                    Categories[i][j].LoadStyleSettings(curSettings[Categories[i][j].ControlId + "_styles"]);
                    for (uint k = 0; k < Categories[i][j].SubElements.Length; k++) {
                        Categories[i][j].SubElements[k].Visibility = curSettings[Categories[i][j].SubElements[k].ControlId];
                        Categories[i][j].SubElements[k].Changed = true;
                        Categories[i][j].SubElements[k].LoadStyleSettings(curSettings[Categories[i][j].SubElements[k].ControlId + "_styles"]);
                    }
                }
            }
        }
    }
}

void SaveState() {  
    auto settingsObj = Json::Object();
    for (uint i = 0; i < Categories.Length; i++) {
        for (uint j = 0; j < Categories[i].Length; j++) {
            settingsObj[Categories[i][j].ControlId] = Categories[i][j].Visibility;
            settingsObj[Categories[i][j].ControlId + "_styles"] = Categories[i][j].SaveStyleSettings();
            for (uint k = 0; k < Categories[i][j].SubElements.Length; k++) {
                settingsObj[Categories[i][j].SubElements[k].ControlId] = Categories[i][j].SubElements[k].Visibility;
                settingsObj[Categories[i][j].SubElements[k].ControlId + "_styles"] = Categories[i][j].SubElements[k].SaveStyleSettings();
            }
        }
    }
    Json::ToFile(IO::FromStorageFolder(settingFileName), settingsObj);
}

void OnSettingsSave(Settings::Section& section) {
    SaveState();
}
