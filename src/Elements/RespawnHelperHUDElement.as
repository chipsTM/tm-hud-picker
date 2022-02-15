class RespawnHelperHUDElement : HUDElement {
    RespawnHelperHUDElement() {
        super("Respawn Helper", "UIModule_Race_RespawnHelper", "");
    }

    bool GetVisible() override {
        return respawnhelperVisible;
    }

    void SetVisible(bool v) override {
        respawnhelperVisible = v;
    }
    
}
RespawnHelperHUDElement@ respawnhelper = RespawnHelperHUDElement(); 