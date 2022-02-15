class CheckpointHUDElement : HUDElement {
    CheckpointHUDElement() {
        super("Checkpoint (Split Time)", "UIModule_Race_Checkpoint", "");
    }

    bool GetVisible() override {
        return checkpointVisible;
    }

    void SetVisible(bool v) override {
        checkpointVisible = v;
    }
    
}
CheckpointHUDElement@ checkpoint = CheckpointHUDElement(); 