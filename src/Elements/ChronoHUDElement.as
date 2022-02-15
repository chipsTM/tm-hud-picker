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
    
}
ChronoHUDElement@ chrono = ChronoHUDElement(); 