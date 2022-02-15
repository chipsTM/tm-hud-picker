class RaceTimeHUDElement : HUDElement {
    RaceTimeHUDElement() {
        super(" Race Time", "UIModule_Race_Checkpoint", "frame-race-time");
    }

    bool GetVisible() override {
        return racetimeVisible;
    }

    void SetVisible(bool v) override {
        racetimeVisible = v;
    }

}
RaceTimeHUDElement@ racetime = RaceTimeHUDElement(); 