enum IndexStatus {
    NotFound = -2,
    NeedsUpdate = -1,
}

class UILayerWrapper {
    string ControlId;
    string DisplayName;
    bool Visibility;
    bool ServerVisibility;
    string Description;
    int Index;
    bool Changed;
    array<UILayerWrapper@> SubElements;


    UILayerWrapper(const string &in controlId, const string &in displayName, const string &in description) {
        ControlId = controlId;
        DisplayName = displayName;
        Description = description;
        Index = IndexStatus::NeedsUpdate;
        Visibility = true;
        ServerVisibility = true;
        Changed = false;
        SubElements = {};
    }

    UILayerWrapper(const string &in controlId, const string &in displayName, const string &in description, array<UILayerWrapper@> subelements) {
        ControlId = controlId;
        DisplayName = displayName;
        Description = description;
        Index = IndexStatus::NeedsUpdate;
        Visibility = true;
        ServerVisibility = true;
        Changed = false;
        SubElements = subelements;
    }

    void ResetIndex() {
        Index = IndexStatus::NeedsUpdate;
        ServerVisibility = true;
    }

    void UpdateIndex() {
        if (!gameInfo.IsPlaying()) return;
        if (Index == IndexStatus::NotFound || Index >= 0) return;
        if (Index == IndexStatus::NeedsUpdate) {
            array<string> parts = ControlId.Split("|");
            for (uint i = 0; i < gameInfo.NetworkUILayers.Length; i++) {
                CGameManialinkPage@ Page = gameInfo.NetworkUILayers[i].LocalPage;
                CGameManialinkControl@ control;
                if (parts.Length > 1) {
                    @control = Page.GetFirstChild(parts[parts.Length-1]);
                } else {
                    @control = Page.GetFirstChild(parts[0]);
                }
                if (control !is null) {
                    Index = i;
                    ServerVisibility = control.Visible;
                    Changed = true;
                    return;
                } else {
                    continue;
                }
            }
        }
        Index = IndexStatus::NotFound;
    }

    void ResetVisibility() {
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        array<string> parts = ControlId.Split("|");
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;

        // Handle SubElements First
        if (parts.Length > 1) {
            CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
            if (control is null) return;

            array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
            while (!frames.IsEmpty()) {
                if (ServerVisibility) {
                    frames[0].Show();
                } else {
                    frames[0].Hide();
                }
                MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
                for (uint i = 0; i < children.Length; i++) {
                    if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                        frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                    } else {
                        if (ServerVisibility) {
                            children[i].Show();
                        } else {
                            children[i].Hide();
                        }
                    }
                }
                frames.RemoveAt(0);
            }
            return;
        }

        // Handle top-level element without SubElements
        auto c = Page.GetFirstChild(parts[0]);
        if (c is null) return;
        if (c.ControlId != parts[0]) return;
        if (ServerVisibility) {
            c.Show();
        } else {
            c.Hide();
        }
    }

    void UpdateVisibility() {
        if (!Changed) return;
        if (!gameInfo.IsPlaying() || Index == IndexStatus::NotFound || Index == IndexStatus::NeedsUpdate) return;
        array<string> parts = ControlId.Split("|");
        CGameManialinkPage@ Page = gameInfo.NetworkUILayers[Index].LocalPage;

        // Handle SubElements First
        if (parts.Length > 1) {
            CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
            if (control is null) return;
            if (!ServerVisibility) return;

            array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
            while (!frames.IsEmpty()) {
                if (Visibility) {
                    frames[0].Show();
                } else {
                    frames[0].Hide();
                }
                MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
                for (uint i = 0; i < children.Length; i++) {
                    if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                        frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                    } else {
                        if (Visibility) {
                            children[i].Show();
                        } else {
                            children[i].Hide();
                        }
                    }
                }
                frames.RemoveAt(0);
            }
            Changed = false;
            return;
        }

        // Handle top-level element without SubElements
        auto c = Page.GetFirstChild(parts[0]);
        if (c is null) return;
        if (c.ControlId != parts[0]) return;
        if (!ServerVisibility) return;        
        if (Visibility) {
            c.Show();
        } else {
            c.Hide();
        }
        Changed = false;
    }

    // Styles functions to be overloaded
    void ResetStyles() {}
    void UpdateStyles() {}
    void RenderStyleSettings() {}
    void LoadStyleSettings(Json::Value@) {}
    Json::Value@ SaveStyleSettings() { auto styleSettingsObj = Json::Object(); return styleSettingsObj; }
}
