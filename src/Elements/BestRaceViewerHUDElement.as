class BestRaceViewerHUDElement : HUDElement {
    BestRaceViewerHUDElement() {
        super("Best Race Viewer", "UIModule_TimeAttack_BestRaceViewer", "");
    }

    bool GetVisible() override {
        return bestraceviewerVisible;
    }

    void SetVisible(bool v) override {
        bestraceviewerVisible = v;
    }
    
}
BestRaceViewerHUDElement@ bestraceviewer = BestRaceViewerHUDElement(); 