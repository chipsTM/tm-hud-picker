class RecordHUDElement : HUDElement {
    RecordHUDElement() {
        super("Records", "UIModule_Race_Record", "");
    }

    bool GetVisible() override {
        return recordVisible;
    }

    void SetVisible(bool v) override {
        recordVisible = v;
    }
    
}
RecordHUDElement@ record = RecordHUDElement(); 