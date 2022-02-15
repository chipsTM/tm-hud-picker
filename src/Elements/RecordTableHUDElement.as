class RecordTableHUDElement : HUDElement {
    RecordTableHUDElement() {
        super(" Record Table", "UIModule_Race_Record", "frame-content");
    }

    bool GetVisible() override {
        return recordtableVisible;
    }

    void SetVisible(bool v) override {
        recordtableVisible = v;
    }
    
}
RecordTableHUDElement@ recordtable = RecordTableHUDElement(); 