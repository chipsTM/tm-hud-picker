class RaceRankHUDElement : HUDElement {
    RaceRankHUDElement() {
        super(" Race Rank", "UIModule_Race_Checkpoint", "frame-race-rank");
    }

    bool GetVisible() override {
        return racerankVisible;
    }

    void SetVisible(bool v) override {
        racerankVisible = v;
    }
    
}
RaceRankHUDElement@ racerank = RaceRankHUDElement(); 