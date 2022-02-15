void RenderMenuMain() {
#if TMNEXT
    if (showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {

        UI::Text("\\$9CFRace\\$z");
        for (uint i = 0; i < raceElements.Length; i++) {
            if(UI::MenuItem(raceElements[i].MenuText(), "", raceElements[i].GetVisible(), (!raceElements[i].SubModules.IsEmpty() && !raceElements[i].Module.IsVisible) ? false : true )) {
                raceElements[i].SetVisible(!raceElements[i].GetVisible());
            }
        }

        UI::Separator();
        UI::Text("\\$9CFTime Attack\\$z");
        for (uint i = 0; i < timeattackElements.Length; i++) {
            if(UI::MenuItem(timeattackElements[i].MenuText(), "", timeattackElements[i].GetVisible(), (!timeattackElements[i].SubModules.IsEmpty() && !timeattackElements[i].Module.IsVisible) ? false : true )) {
                timeattackElements[i].SetVisible(!timeattackElements[i].GetVisible());
            }
        }

        UI::Separator();
        UI::Text("\\$9CFKnockout\\$z");
        for (uint i = 0; i < knockoutElements.Length; i++) {
            if(UI::MenuItem(knockoutElements[i].MenuText(), "", knockoutElements[i].GetVisible(), (!knockoutElements[i].SubModules.IsEmpty() && !knockoutElements[i].Module.IsVisible) ? false : true )) {
                knockoutElements[i].SetVisible(!knockoutElements[i].GetVisible());
            }
        }

        UI::EndMenu();
    }
#endif
}

void RenderMenu() {
#if TMNEXT
    if (!showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {

        UI::Text("\\$9CFRace\\$z");
        for (uint i = 0; i < raceElements.Length; i++) {
            if(UI::MenuItem(raceElements[i].MenuText(), "", raceElements[i].GetVisible(), (!raceElements[i].SubModules.IsEmpty() && !raceElements[i].Module.IsVisible) ? false : true )) {
                raceElements[i].SetVisible(!raceElements[i].GetVisible());
            }
        }

        UI::Separator();
        UI::Text("\\$9CFTime Attack\\$z");
        for (uint i = 0; i < timeattackElements.Length; i++) {
            if(UI::MenuItem(timeattackElements[i].MenuText(), "", timeattackElements[i].GetVisible(), (!timeattackElements[i].SubModules.IsEmpty() && !timeattackElements[i].Module.IsVisible) ? false : true )) {
                timeattackElements[i].SetVisible(!timeattackElements[i].GetVisible());
            }
        }

        UI::Separator();
        UI::Text("\\$9CFKnockout\\$z");
        for (uint i = 0; i < knockoutElements.Length; i++) {
            if(UI::MenuItem(knockoutElements[i].MenuText(), "", knockoutElements[i].GetVisible(), (!knockoutElements[i].SubModules.IsEmpty() && !knockoutElements[i].Module.IsVisible) ? false : true )) {
                knockoutElements[i].SetVisible(!knockoutElements[i].GetVisible());
            }
        }

        UI::EndMenu();
    }
#endif
}


bool halt = false;
void Main() {
#if TMNEXT
    CTrackMania@ app = cast<CTrackMania>(GetApp());
    CTrackManiaNetwork@ network = cast<CTrackManiaNetwork>(app.Network);
    while(true && !halt) {
        if (network.ClientManiaAppPlayground !is null && network.ClientManiaAppPlayground.Playground !is null && network.ClientManiaAppPlayground.Playground.Map !is null) {
            auto uilayers = network.ClientManiaAppPlayground.UILayers;

            for (uint i = 0; i < raceElements.Length; i++) {
                if (!raceElements[i].Checked) {
                    raceElements[i].FindElements(uilayers);
                } else {
                    raceElements[i].UpdateVisibilty();
                }
            }
            for (uint i = 0; i < timeattackElements.Length; i++) {
                if (!timeattackElements[i].Checked) {
                    timeattackElements[i].FindElements(uilayers);
                } else {
                    timeattackElements[i].UpdateVisibilty();
                }
            }
            for (uint i = 0; i < knockoutElements.Length; i++) {
                if (!knockoutElements[i].Checked) {
                    knockoutElements[i].FindElements(uilayers);
                } else {
                    knockoutElements[i].UpdateVisibilty();
                }
            }
        } else {
            // reset all handles to elements when we switch maps/leave current map
            for (uint i = 0; i < raceElements.Length; i++) {
                if (raceElements[i].Checked) {
                    raceElements[i].Checked = false;
                    @raceElements[i].Module = null;
                    raceElements[i].SubModules.RemoveRange(0, raceElements[i].SubModules.Length);
                }
            }
            for (uint i = 0; i < timeattackElements.Length; i++) {
                if (timeattackElements[i].Checked) {
                    timeattackElements[i].Checked = false;
                    @timeattackElements[i].Module = null;
                    timeattackElements[i].SubModules.RemoveRange(0, timeattackElements[i].SubModules.Length);
                }
            }
            for (uint i = 0; i < knockoutElements.Length; i++) {
                if (knockoutElements[i].Checked) {
                    knockoutElements[i].Checked = false;
                    @knockoutElements[i].Module = null;
                    knockoutElements[i].SubModules.RemoveRange(0, knockoutElements[i].SubModules.Length);
                }
            }
        }
        sleep(100);
    }
    error("Script halted");
#endif
}
