class RaceTimeDiffHUDElement : HUDElement {
    RaceTimeDiffHUDElement() {
        super(" Race Time Difference", "UIModule_Race_Checkpoint", "frame-race-diff");
    }

    bool GetVisible() override {
        return racetimediffVisible;
    }

    void SetVisible(bool v) override {
        racetimediffVisible = v;
    }

}
RaceTimeDiffHUDElement@ racetimediff = RaceTimeDiffHUDElement(); 