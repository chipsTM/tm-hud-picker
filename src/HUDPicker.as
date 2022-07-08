void HUDPickerUI() {
    UI::Text("\\$9CFRace\\$z");
    for (uint i = 0; i < raceElements.Length; i++) {
        if(UI::MenuItem(raceElements[i].MenuText(), "", raceElements[i].GetVisible(), (raceElements[i].SubModuleName != "" && !raceElements[i].IsParentVisible(uilayers[raceElements[i].ModuleIndex])) ? false : true )) {
            raceElements[i].SetVisible(!raceElements[i].GetVisible());
        }
    }

    UI::Separator();
    UI::Text("\\$9CFTime Attack\\$z");
    for (uint i = 0; i < timeattackElements.Length; i++) {
        if(UI::MenuItem(timeattackElements[i].MenuText(), "", timeattackElements[i].GetVisible(), (timeattackElements[i].SubModuleName != "" && !timeattackElements[i].IsParentVisible(uilayers[timeattackElements[i].ModuleIndex])) ? false : true )) {
            timeattackElements[i].SetVisible(!timeattackElements[i].GetVisible());
        }
    }

    UI::Separator();
    UI::Text("\\$9CFKnockout\\$z");
    for (uint i = 0; i < knockoutElements.Length; i++) {
        if(UI::MenuItem(knockoutElements[i].MenuText(), "", knockoutElements[i].GetVisible(), (knockoutElements[i].SubModuleName != "" && !knockoutElements[i].IsParentVisible(uilayers[knockoutElements[i].ModuleIndex])) ? false : true )) {
            knockoutElements[i].SetVisible(!knockoutElements[i].GetVisible());
        }
    }

    UI::EndMenu();
}

void RenderMenuMain() {
#if TMNEXT
    if (showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {
        HUDPickerUI();
    }
#endif
}

void RenderMenu() {
#if TMNEXT
    if (!showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {
        HUDPickerUI();
    }
#endif
}

MwFastBuffer<CGameUILayer@> uilayers;

void Main() {
#if TMNEXT
    auto app = cast<CTrackMania>(GetApp());
    auto loadMgr = app.LoadProgress;
    auto network = cast<CTrackManiaNetwork>(app.Network);

    while(true) {
        // wait until playground finishes loading
        while (loadMgr.State == NGameLoadProgress_SMgr::EState::Displayed) {
            yield();
        }
        auto playground = app.CurrentPlayground;
        if (playground !is null) {
            if (network.ClientManiaAppPlayground !is null && network.ClientManiaAppPlayground.Playground !is null && network.ClientManiaAppPlayground.UILayers.Length > 0 && playground.GameTerminals.Length > 0) {
                uilayers = network.ClientManiaAppPlayground.UILayers;
                
                auto uiseq = playground.GameTerminals[0].UISequence_Current;
                if (uiseq == SGamePlaygroundUIConfig::EUISequence::Playing) {
                    for (uint i = 0; i < raceElements.Length; i++) {
                        if (raceElements[i].ModuleIndex != -1 && raceElements[i].ModuleIndex < int(uilayers.Length)) {
                            raceElements[i].UpdateVisibilty(uilayers[raceElements[i].ModuleIndex]);
                        } else {
                            raceElements[i].FindElements(uilayers);
                        }
                    }
                    for (uint i = 0; i < timeattackElements.Length; i++) {
                        if (timeattackElements[i].ModuleIndex != -1 && timeattackElements[i].ModuleIndex < int(uilayers.Length)) {
                            timeattackElements[i].UpdateVisibilty(uilayers[timeattackElements[i].ModuleIndex]);
                        } else {
                            timeattackElements[i].FindElements(uilayers);
                        }
                    }
                    for (uint i = 0; i < knockoutElements.Length; i++) {
                        if (knockoutElements[i].ModuleIndex != -1 && knockoutElements[i].ModuleIndex < int(uilayers.Length)) {
                            knockoutElements[i].UpdateVisibilty(uilayers[knockoutElements[i].ModuleIndex]);
                        } else {
                            knockoutElements[i].FindElements(uilayers);
                        }
                    }
                }
            }
        }
        sleep(100);
    }
#endif
}