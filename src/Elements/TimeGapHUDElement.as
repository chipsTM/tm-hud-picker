class TimeGapHUDElement : HUDElement {
    TimeGapHUDElement() {
        super("Time Gap", "UIModule_Race_TimeGap", "");
    }

    bool GetVisible() override {
        return timegapVisible;
    }

    void SetVisible(bool v) override {
        timegapVisible = v;
    }
    
}
TimeGapHUDElement@ timegap = TimeGapHUDElement(); 