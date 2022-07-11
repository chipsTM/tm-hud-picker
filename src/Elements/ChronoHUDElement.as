class ChronoHUDElement : HUDElement {
    ChronoHUDElement() {
        super("Chronometer", "UIModule_Race_Chrono", "");
    }

    bool GetVisible() override {
        return chronoVisible;
    }

    void SetVisible(bool v) override {
        chronoVisible = v;
    }
    
    void ClipDigit(CGameUILayer@ layer) {
        CGameManialinkFrame@ mframe = cast<CGameManialinkFrame@>(layer.LocalPage.GetFirstChild("frame-chrono"));
        CGameManialinkLabel@ mlabel = cast<CGameManialinkLabel@>(layer.LocalPage.GetFirstChild("label-chrono"));
        if (mframe !is null && mlabel !is null) {
            float textWidth = mlabel.ComputeWidth(mlabel.Value);
            float lastdigitWidth = 0;
            // This is only because wstring doesn't currently have a Length prop
            // can remove cast in future OP update
            string ld = string(mlabel.Value);
            if (ld.Length > 0) {
                lastdigitWidth = mlabel.ComputeWidth(mlabel.Value.SubStr(ld.Length-1, 1));
            }
            if (Regex::Contains(mlabel.Value, "\\.\\d{3}")) {
                mframe.ClipWindowActive = false;
                mframe.ClipWindowSize = vec2(0,0);
                mframe.RelativePosition_V3 = vec2(0,0);
                mlabel.RelativePosition_V3 = vec2(0,0);
            } else {
                if (clipChrono) {
                    mframe.ClipWindowActive = true;
                    mframe.ClipWindowSize = vec2(textWidth,mlabel.Size.y);
                    mframe.RelativePosition_V3 = vec2(-lastdigitWidth/2,0);
                    mlabel.RelativePosition_V3 = vec2(lastdigitWidth,0);
                } else {
                    mframe.ClipWindowActive = false;
                    mframe.ClipWindowSize = vec2(0,0);
                    mframe.RelativePosition_V3 = vec2(0,0);
                    mlabel.RelativePosition_V3 = vec2(0,0);
                }
            }
        }
    }

}
ChronoHUDElement@ chrono = ChronoHUDElement(); 