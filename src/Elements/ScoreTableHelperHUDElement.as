class ScoreTableHelperHUDElement : HUDElement {
    ScoreTableHelperHUDElement() {
        super("Scores Table Helper", "UIModule_Campaign_ScorestableHelper", "");
    }

    bool GetVisible() override {
        return scorestablehelperVisible;
    }

    void SetVisible(bool v) override {
        scorestablehelperVisible = v;
    }
    
}
ScoreTableHelperHUDElement@ scorestablehelper = ScoreTableHelperHUDElement(); 