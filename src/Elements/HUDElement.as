class HUDElement {
    string Name;
    string ModuleName;
    int ModuleIndex;
    string SubModuleName;
    bool GetVisible() { return true; }
    void SetVisible(bool v) { }

    HUDElement(const string &in name, const string &in moduleName, const string &in subModuleName = "") {
        this.Name = name;
        this.ModuleName = moduleName;
        this.ModuleIndex = -1;
        this.SubModuleName = subModuleName;
    }

    string MenuText() {
        return (this.GetVisible() ? "\\$7F7" : "\\$FFF") + this.Name + "\\$z";
    }

    bool IsParentVisible(CGameUILayer@ curLayer) {
        if (this.Exists(curLayer)) {
            return curLayer.IsVisible;
        }
        return false;
    }

    void SetStyle(CGameUILayer@ layer) {}

    bool Exists(CGameUILayer@ curLayer) {
        int start = curLayer.ManialinkPageUtf8.IndexOf("<");
        int end = curLayer.ManialinkPageUtf8.IndexOf(">");
        if (start != -1 && end != -1) {
            auto manialinkname = curLayer.ManialinkPageUtf8.SubStr(start, end);
            if (manialinkname.Contains(this.ModuleName)) {
                return true;
            }
        }
        this.ModuleIndex = -1;
        return false;
    }

    void FindElements(MwFastBuffer<CGameUILayer@> &in uilayers) {
        for (uint i = 0; i < uilayers.Length; i++) {
            CGameUILayer@ curLayer = uilayers[i];
            int start = curLayer.ManialinkPageUtf8.IndexOf("<");
            int end = curLayer.ManialinkPageUtf8.IndexOf(">");
            if (start != -1 && end != -1) {
                auto manialinkname = curLayer.ManialinkPageUtf8.SubStr(start, end);
                if (manialinkname.Contains(this.ModuleName)) {
                    this.ModuleIndex = i;
                    break; // we don't need to continue further
                }
            }
        }
    }

    void UpdateVisibilty(CGameUILayer@ layer) {
        if (this.Exists(layer)) {
            if (this.ModuleName != "" && this.SubModuleName == "") {
                if (this.GetVisible() != layer.IsVisible) {
                    layer.IsVisible = !layer.IsVisible;
                }
            } else if (this.ModuleName != "" && this.SubModuleName != "") {
                CControlFrame@ c = cast<CControlFrame@>(layer.LocalPage.GetFirstChild(this.SubModuleName).Control);
                if (c !is null) {
                    array<CControlFrame@> frames  = { c };
                    while (!frames.IsEmpty()) {
                        auto children = frames[0].Childs;
                        for (uint j = 0; j < children.Length; j++) {
                            if (Reflection::TypeOf(children[j]).Name == "CControlFrame") {
                                frames.InsertLast(cast<CControlFrame@>(children[j]));
                            } else {
                                auto subModule = cast<CControlBase@>(children[j]);
                                if (this.GetVisible() && !subModule.IsVisible) {
                                    subModule.Show();
                                } else if (!this.GetVisible() && subModule.IsVisible) {
                                    subModule.Hide();
                                }
                            }
                        }
                        frames.RemoveAt(0);
                    }
                } else {
                    error("SubModule could not be found");
                }
            }
        }
    }

}