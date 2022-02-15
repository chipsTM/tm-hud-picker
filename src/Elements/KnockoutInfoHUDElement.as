class KnockoutInfoHUDElement : HUDElement {
    KnockoutInfoHUDElement() {
        super("Knockout Info", "UIModule_Knockout_KnockoutInfo", "");
    }

    bool GetVisible() override {
        return knockoutinfoVisible;
    }

    void SetVisible(bool v) override {
        knockoutinfoVisible = v;
    }
    
}
KnockoutInfoHUDElement@ knockoutinfo = KnockoutInfoHUDElement(); 