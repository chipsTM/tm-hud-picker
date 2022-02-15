class MedalStackHUDElement : HUDElement {
    MedalStackHUDElement() {
        super(" Medal Stack", "UIModule_Race_Record", "clip-medal-banner");
    }

    bool GetVisible() override {
        return medalstackVisible;
    }

    void SetVisible(bool v) override {
        medalstackVisible = v;
    }
    
}
MedalStackHUDElement@ medalstack = MedalStackHUDElement(); 