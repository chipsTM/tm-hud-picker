class MedalCelebrationHUDElement : HUDElement {
    MedalCelebrationHUDElement() {
        super(" Medal Celebration", "UIModule_Race_Record", "frame-celebration");
    }

    bool GetVisible() override {
        return medalcelebrationVisible;
    }

    void SetVisible(bool v) override {
        medalcelebrationVisible = v;
    }

}
MedalCelebrationHUDElement@ medalcelebration = MedalCelebrationHUDElement(); 