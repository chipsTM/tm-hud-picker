class HUDElement {
    string Name;
    string ModuleName;
    CGameUILayer@ Module;
    string SubModuleName;
    array<CGameManialinkControl@> SubModules;
    bool Checked;
    bool GetVisible() { return true; }
    void SetVisible(bool v) { }

    HUDElement(const string &in name, const string &in moduleName, string subModuleName = "") {
        this.Name = name;
        this.ModuleName = moduleName;
        this.SubModuleName = subModuleName;
        this.Checked = false;
    }

    string MenuText() {
        return (this.GetVisible() ? "\\$7F7" : "\\$FFF") + this.Name + "\\$z";
    }

    void FindElements(MwFastBuffer<CGameUILayer@> uilayers) {
        for (uint i = 0; i < uilayers.Length; i++) {
            CGameUILayer@ curLayer = uilayers[i];
            int start = curLayer.ManialinkPageUtf8.IndexOf("<");
            int end = curLayer.ManialinkPageUtf8.IndexOf(">");
            if (start != -1 && end != -1) {
                auto manialinkname = curLayer.ManialinkPageUtf8.SubStr(start, end);
                if (manialinkname.Contains(this.ModuleName)) {
                    @this.Module = @curLayer;

                    if (this.SubModuleName != "") {
                        // NOTE: we need to show/hide individual controls instead of the parent frame container. Otherwise causes flickering.
                        
                        // We recursively get the sub controls of the frame to individually hide/show.
                        CGameManialinkFrame@ c = cast<CGameManialinkFrame@>(curLayer.LocalPage.GetFirstChild(this.SubModuleName));
                        if (c !is null) {
                            array<CGameManialinkFrame@> frames = { c };
                            while (!frames.IsEmpty()) {
                                MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
                                for (uint j = 0; j < children.Length; j++) {
                                    if (Reflection::TypeOf(children[j]).Name == "CGameManialinkFrame") {
                                        frames.InsertLast(cast<CGameManialinkFrame@>(children[j]));
                                    } else {
                                        this.SubModules.InsertLast(cast<CGameManialinkControl@>(children[j]));
                                    }
                                }
                                frames.RemoveAt(0);
                            }
                        }
                    }
                    this.Checked = true;
                    break; // we don't need to continue further
                } 
            }
        }
        this.Checked = true;
    }

    void UpdateVisibilty() {
        if (this.Module !is null && this.SubModules.IsEmpty()) {
            if (this.GetVisible() != this.Module.IsVisible) {
                this.Module.IsVisible = !this.Module.IsVisible;
            }
        } else if (this.Module !is null && !this.SubModules.IsEmpty()) {
            for (uint i = 0; i < this.SubModules.Length; i++) {
                if (this.GetVisible() && this.SubModules[i] !is null && !this.SubModules[i].Visible) {
                    this.SubModules[i].Show();
                } else if (!this.GetVisible() && this.SubModules[i] !is null  && this.SubModules[i].Visible) {
                    this.SubModules[i].Hide();
                }
            }
        }
    }
}