class CountdownHUDElement : HUDElement {
    CountdownHUDElement() {
        super("Countdown", "UIModule_Race_Countdown", "");
    }

    bool GetVisible() override {
        return countdownVisible;
    }

    void SetVisible(bool v) override {
        countdownVisible = v;
    }
    
}
CountdownHUDElement@ countdown = CountdownHUDElement(); 