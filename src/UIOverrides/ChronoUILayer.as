// Chrono Layer override to support custom styles
class ChronoUILayer : UILayerWrapper {
    // "label-chrono" properties; these should be the defaults when plugin is disabled
    vec3 TextColor = vec3(1.0, 1.0, 1.0);
    bool RainbowEnabled = false;
    float RainbowRate = 0.001;
    float RainbowVal = 0.0;
    bool ClipDigit = false;
    vec2 DefaultChronoPosition = vec2(0.0, -80.0);
    vec2 ChronoPosition = DefaultChronoPosition;


    ChronoUILayer(const string &in controlId, const string &in displayName, const string &in description) {
        super(controlId, displayName, description);
    }

    ChronoUILayer(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        super(controlId, displayName, description, subelements);
    }

    void ResetStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ chrono_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Chrono"));
        CGameManialinkFrame@ frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("frame-chrono"));
        CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(Page.GetFirstChild("label-chrono"));
        if (chrono_frame is null || frame is null || label is null) return;

        label.TextColor = vec3(1.0, 1.0, 1.0);
        frame.ClipWindowActive = false;
        frame.ClipWindowSize = vec2(1, 1);
        frame.RelativePosition_V3 = vec2(0, 0);
        label.RelativePosition_V3 = vec2(0, 0);
        chrono_frame.RelativePosition_V3 = DefaultChronoPosition;
    }

    void UpdateStyles() override {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;
        CGameManialinkFrame@ chrono_frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("Race_Chrono"));
        CGameManialinkFrame@ frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("frame-chrono"));
        CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(Page.GetFirstChild("label-chrono"));
        if (frame is null || label is null) return;

        // Position Logic
        chrono_frame.RelativePosition_V3 = ChronoPosition;

        // Color Logic
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

        // Clip Digit Logic
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
        UI::SetNextItemWidth(300.0);
        float newX = UI::SliderFloat("Position X", ChronoPosition.x, -uiBounds.x/2, uiBounds.x/2, "%.0f");
        UI::SetNextItemWidth(300.0);
        float newY = UI::SliderFloat("Position Y", ChronoPosition.y, -uiBounds.y/2, uiBounds.y/2, "%.0f");
        ChronoPosition = vec2(newX, newY);
        if (UI::Button("Reset Position")) {
            ChronoPosition = DefaultChronoPosition;
        }
        UI::SetNextItemWidth(450.0);
        TextColor = UI::InputColor3("Text Color", TextColor);
        RainbowEnabled = UI::Checkbox("Enable Rainbow", RainbowEnabled);
        UI::SameLine();
        UI::SetNextItemWidth(300.0);
        RainbowRate = UI::SliderFloat("Rainbow Rate", RainbowRate, 0.001, 0.1);
        ClipDigit = UI::Checkbox("Clip Digit", ClipDigit);
    }

    void LoadStyleSettings(Json::Value@ styleSettings) override {
        TextColor = vec3(styleSettings["text_color"][0], styleSettings["text_color"][1], styleSettings["text_color"][2]);
        RainbowEnabled = styleSettings["enable_rainbow"];
        RainbowRate = styleSettings["rainbow_rate"];
        ClipDigit = styleSettings["clip_digit"];
        if (styleSettings.HasKey("chrono_position") && styleSettings["chrono_position"].GetType() != Json::Type::Null) {
            ChronoPosition = vec2(styleSettings["chrono_position"][0], styleSettings["chrono_position"][1]);
        }
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
        styleSettingsObj["chrono_position"] = Json::Array();
        styleSettingsObj["chrono_position"].Add(ChronoPosition.x);
        styleSettingsObj["chrono_position"].Add(ChronoPosition.y);
        return styleSettingsObj;
    }
}