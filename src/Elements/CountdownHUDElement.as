class CountdownHUDElement : HUDElement {
    float i = Math::Rand(0.0, 1.0);

    CountdownHUDElement() {
        super("Countdown", "UIModule_Race_Countdown", "");
    }

    bool GetVisible() override {
        return countdownVisible;
    }

    void SetVisible(bool v) override {
        countdownVisible = v;
    }
    
    void SetStyle(CGameUILayer@ layer) override{
        CGameManialinkLabel@ mlabel = cast<CGameManialinkLabel@>(layer.LocalPage.GetFirstChild("label-countdown"));
        CGameManialinkFrame@ mframe = cast<CGameManialinkFrame@>(layer.LocalPage.GetFirstChild("frame-countdown"));
        if (mlabel !is null && mframe !is null) {
            auto controlsContainer = cast<CControlContainer@>(mframe.Control);
            auto oldCountDown = controlsContainer.Childs[0];
            mlabel.Visible = false;
            if (controlsContainer.Childs.Length == 1) {
                controlsContainer.AddInstance(oldCountDown, "", vec3(0,0,0));
            }
            auto newCountDown = controlsContainer.Childs[1];
            newCountDown.Show();

            cast<CControlLabel@>(newCountDown).Label = cast<CControlLabel@>(oldCountDown).Label;
            auto parts = string(cast<CControlLabel@>(oldCountDown).Label).Split(":");
            if (parts.Length == 2 && Text::ParseInt(parts[0]) * 60 + Text::ParseInt(parts[1]) <= 30) {
                // set text to red when 30 seconds or less
                newCountDown.Style.LabelColor = vec3(1.0,0.0,0.0);
            } else {
                if (rainbowRoad) {
                    if (i > 1.0) {
                        i = 0.0;
                    }
                    vec4 newColor = UI::HSV(i, 1.0, 1.0);
                    newCountDown.Style.LabelColor = vec3(newColor.x, newColor.y, newColor.z);
                    i += rate;
                } else if (enableGlobalColor) {
                    newCountDown.Style.LabelColor = globalColor;
                } else {
                    newCountDown.Style.LabelColor = countdownColor;
                }
                if (enableGlobalOpacity) {
                    newCountDown.Style.LabelColorAlpha = globalOpacity;
                } else {
                    newCountDown.Style.LabelColorAlpha = countdownOpacity;
                }
            }
        }
    }
}
CountdownHUDElement@ countdown = CountdownHUDElement(); 