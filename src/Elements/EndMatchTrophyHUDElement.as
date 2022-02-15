class EndMatchTrophyHUDElement : HUDElement {
    EndMatchTrophyHUDElement() {
        super("End Match Trophy", "UIModule_TimeAttack_EndMatchTrophy", "");
    }

    bool GetVisible() override {
        return endmatchtrophyVisible;
    }

    void SetVisible(bool v) override {
        endmatchtrophyVisible = v;
    }
    
}
EndMatchTrophyHUDElement@ endmatchtrophy = EndMatchTrophyHUDElement(); 