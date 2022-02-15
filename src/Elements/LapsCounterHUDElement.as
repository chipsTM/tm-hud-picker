class LapsCounterHUDElement : HUDElement {
    LapsCounterHUDElement() {
        super("Laps Counter", "UIModule_Race_LapsCounter", "");
    }

    bool GetVisible() override {
        return lapscounterVisible;
    }

    void SetVisible(bool v) override {
        lapscounterVisible = v;
    }
    
}
LapsCounterHUDElement@ lapscounter = LapsCounterHUDElement(); 