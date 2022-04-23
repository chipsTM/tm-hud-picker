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

void OnDestroyed() {
    // reset all handles to elements when we switch maps/leave current map
    for (uint i = 0; i < raceElements.Length; i++) {
        raceElements[i].Checked = false;
        @raceElements[i].Module = null;
        raceElements[i].SubModules.RemoveRange(0, raceElements[i].SubModules.Length);
    }
    for (uint i = 0; i < timeattackElements.Length; i++) {
        timeattackElements[i].Checked = false;
        @timeattackElements[i].Module = null;
        timeattackElements[i].SubModules.RemoveRange(0, timeattackElements[i].SubModules.Length);
    }
    for (uint i = 0; i < knockoutElements.Length; i++) {
        knockoutElements[i].Checked = false;
        @knockoutElements[i].Module = null;
        knockoutElements[i].SubModules.RemoveRange(0, knockoutElements[i].SubModules.Length);
    }
}

void OnDisabled() {
    // reset all handles to elements when we switch maps/leave current map
    for (uint i = 0; i < raceElements.Length; i++) {
        raceElements[i].Checked = false;
        @raceElements[i].Module = null;
        raceElements[i].SubModules.RemoveRange(0, raceElements[i].SubModules.Length);
    }
    for (uint i = 0; i < timeattackElements.Length; i++) {
        timeattackElements[i].Checked = false;
        @timeattackElements[i].Module = null;
        timeattackElements[i].SubModules.RemoveRange(0, timeattackElements[i].SubModules.Length);
    }
    for (uint i = 0; i < knockoutElements.Length; i++) {
        knockoutElements[i].Checked = false;
        @knockoutElements[i].Module = null;
        knockoutElements[i].SubModules.RemoveRange(0, knockoutElements[i].SubModules.Length);
    }
}


bool halt = false;
void Main() {
#if TMNEXT
    auto app = cast<CTrackMania>(GetApp());
    auto loadMgr = app.LoadProgress;
    auto network = cast<CTrackManiaNetwork>(app.Network);

    while(true && !halt) {
        // wait until playground finishes loading
        while (loadMgr.State == NGameLoadProgress_SMgr::EState::Displayed) {
            yield();
        }
        
        if (network.ClientManiaAppPlayground !is null && network.ClientManiaAppPlayground.Playground !is null && network.ClientManiaAppPlayground.UILayers.Length > 0) {
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
                raceElements[i].Checked = false;
                @raceElements[i].Module = null;
                raceElements[i].SubModules.RemoveRange(0, raceElements[i].SubModules.Length);
            }
            for (uint i = 0; i < timeattackElements.Length; i++) {
                timeattackElements[i].Checked = false;
                @timeattackElements[i].Module = null;
                timeattackElements[i].SubModules.RemoveRange(0, timeattackElements[i].SubModules.Length);
            }
            for (uint i = 0; i < knockoutElements.Length; i++) {
                knockoutElements[i].Checked = false;
                @knockoutElements[i].Module = null;
                knockoutElements[i].SubModules.RemoveRange(0, knockoutElements[i].SubModules.Length);
            }
        }
        sleep(100);
    }
    error("Script halted");
#endif
}
