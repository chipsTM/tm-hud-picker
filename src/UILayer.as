enum IndexStatus {
    NotFound = -2,
    NeedsUpdate = -1,
}

class UILayerWrapper {
    string ControlId;
    string DisplayName;
    bool Visibility;
    bool DefaultVisibility;
    string Description;
    int Index;
    bool Changed;
    array<UILayerWrapper@> SubElements;

        
    UILayerWrapper(const string &in controlId, const string &in displayName, const string &in description) {
        ControlId = controlId;
        DisplayName = displayName;
        Description = description;
        Index = IndexStatus::NeedsUpdate;
        Visibility = true;
        DefaultVisibility = true;
        Changed = false;
        SubElements = {};
    }

    UILayerWrapper(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        ControlId = controlId;
        DisplayName = displayName;
        Description = description;
        Index = IndexStatus::NeedsUpdate;
        Visibility = true;
        DefaultVisibility = true;
        Changed = false;
        SubElements = subelements;
    }

    void ResetIndex() {
        Index = IndexStatus::NeedsUpdate;
    }

    void UpdateIndex() {
        if (!gameInfo.IsPlaying()) return;
        array<string> parts = ControlId.Split("|");
        for (uint i = 0; i < gameInfo.NetworkUILayers.Length; i++) {
            CGameManialinkPage@ Page = gameInfo.NetworkUILayers[i].LocalPage;
            CGameManialinkControl@ control = Page.GetFirstChild(parts[0]);
            if (control !is null) {
                Index = i;
                DefaultVisibility = control.Visible;
                Changed = true;
                return;
            } else {
                continue;
            }
        }
        Index = IndexStatus::NotFound;
    }

    void ResetVisibility() {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        array<string> parts = ControlId.Split("|");
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;

        // Handle SubElements First
        if (parts.Length > 1) {
            CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
            if (control is null) return;

            array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
            while (!frames.IsEmpty()) {
                if (DefaultVisibility) {
                    frames[0].Show();
                } else {
                    frames[0].Hide();
                }
                MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
                for (uint i = 0; i < children.Length; i++) {
                    if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                        frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                    } else {
                        if (DefaultVisibility) {
                            children[i].Show();
                        } else {
                            children[i].Hide();
                        }
                    }
                }
                frames.RemoveAt(0);
            }
            return;
        }

        // Handle top-level element without SubElements
        auto c = Page.GetFirstChild(parts[0]);
        if (c is null) return;
        if (c.ControlId != parts[0]) return;
        if (DefaultVisibility) {
            c.Show();
        } else {
            c.Hide();
        }
    }

    void UpdateVisibility() {
        if (!Changed) return;
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        array<string> parts = ControlId.Split("|");
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        
        // Handle SubElements First
        if (parts.Length > 1) {
            CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
            if (control is null) return;

            array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
            while (!frames.IsEmpty()) {
                if (Visibility) {
                    frames[0].Show();
                } else {
                    frames[0].Hide();
                }
                MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
                for (uint i = 0; i < children.Length; i++) {
                    if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                        frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                    } else {
                        if (Visibility) {
                            children[i].Show();
                        } else {
                            children[i].Hide();
                        }
                    }
                }
                frames.RemoveAt(0);
            }
            Changed = false;
            return;
        }

        // Handle top-level element without SubElements
        auto c = Page.GetFirstChild(parts[0]);
        if (c is null) return;
        if (c.ControlId != parts[0]) return;
        if (!DefaultVisibility) return;
        if (Visibility) {
            c.Show();
        } else {
            c.Hide();
        }
        Changed = false;
    }

    // Styles functions to be overloaded
    void ResetStyles() {}
    void UpdateStyles() {}
    void RenderStyleSettings() {}
    void LoadStyleSettings(Json::Value@) {}
    Json::Value@ SaveStyleSettings() { auto styleSettingsObj = Json::Object(); return styleSettingsObj; }
}

// Chrono Layer override to support custom styles
class ChronoUILayer : UILayerWrapper {
    // "label-chrono" properties; these should be the defaults when plugin is disabled
    vec3 TextColor = vec3(1.0, 1.0, 1.0);
    bool RainbowEnabled = false;
    float RainbowRate = 0.001;
    float RainbowVal = 0.0;
    bool ClipDigit = false;


    ChronoUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    ChronoUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("frame-chrono"));
        CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(Page.GetFirstChild("label-chrono"));
        if (frame is null || label is null) return;

        label.TextColor = vec3(1.0, 1.0, 1.0);
        frame.ClipWindowActive = false;
        frame.ClipWindowSize = vec2(1, 1);
        frame.RelativePosition_V3 = vec2(0, 0);
        label.RelativePosition_V3 = vec2(0, 0);
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("frame-chrono"));
        CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(Page.GetFirstChild("label-chrono"));
        if (frame is null || label is null) return;
        if (RainbowEnabled) {
            if (RainbowVal > 1.0) {
                RainbowVal = 0.0;
            }
            vec4 newColor = UI::HSV(RainbowVal, 1.0, 1.0);
            label.TextColor = newColor.xyz;
            RainbowVal += RainbowRate;
        } else {
            label.TextColor = TextColor;
        }

        if (Regex::Contains(label.Value, "\\.\\d{3}")) {
            frame.ClipWindowActive = false;
            frame.ClipWindowSize = vec2(1, 1);
            frame.RelativePosition_V3 = vec2(0, 0);
            label.RelativePosition_V3 = vec2(0, 0);
        } else {
            if (ClipDigit) {
                frame.ClipWindowActive = true;

                float textWidth = label.ComputeWidth(label.Value);
                float lastdigitWidth = 0.0;
                if (label.Value.Length > 0) {
                    lastdigitWidth = label.ComputeWidth(label.Value.SubStr(label.Value.Length-1, 1));
                }
                // label width should never exceed 40 units 
                float minWidth = Math::Min(textWidth, label.Size.x);
                // Subtract by 2 due to 1 unit padding on BOTH sides of label
                float realWidth = minWidth - 2;
                float scaledDigitWidth = lastdigitWidth * realWidth / textWidth;
                // We use min width minus 1 to account for padding on ONE side; additionally add 2 to y so that shadow isn't cut off
                frame.ClipWindowSize = vec2(minWidth-1, label.Size.y+2);
                frame.RelativePosition_V3 = vec2(-scaledDigitWidth/2, 0);
                label.RelativePosition_V3 = vec2(scaledDigitWidth, 0);
            } else {
                frame.ClipWindowActive = false;
                frame.ClipWindowSize = vec2(1, 1);
                frame.RelativePosition_V3 = vec2(0, 0);
                label.RelativePosition_V3 = vec2(0, 0);
            }
        }
    }

    void RenderStyleSettings() override {
        TextColor = UI::InputColor3("Text Color", TextColor);
        RainbowEnabled = UI::Checkbox("Enable Rainbow", RainbowEnabled);
        RainbowRate = UI::SliderFloat("Rainbow Rate", RainbowRate, 0.001, 0.1);
        ClipDigit = UI::Checkbox("Clip Digit", ClipDigit);
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        TextColor = vec3(styleSettings["text_color"][0], styleSettings["text_color"][1], styleSettings["text_color"][2]);
        RainbowEnabled = styleSettings["enable_rainbow"];
        RainbowRate = styleSettings["rainbow_rate"];
        ClipDigit = styleSettings["clip_digit"];
    }

    Json::Value@ SaveStyleSettings() override {
        auto styleSettingsObj = Json::Object();
        styleSettingsObj["text_color"] = Json::Array();
        styleSettingsObj["text_color"].Add(TextColor.x);
        styleSettingsObj["text_color"].Add(TextColor.y);
        styleSettingsObj["text_color"].Add(TextColor.z);
        styleSettingsObj["enable_rainbow"] = RainbowEnabled;
        styleSettingsObj["rainbow_rate"] = RainbowRate;
        styleSettingsObj["clip_digit"] = ClipDigit;
        return styleSettingsObj;
    }
}
