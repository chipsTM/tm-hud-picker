void HUDPickerUI() {
    UI::Text("\\$9CFRace\\$z");
    for (uint i = 0; i < raceElements.Length; i++) {
        if(UI::MenuItem(raceElements[i].MenuText(), "", raceElements[i].GetVisible(), (raceElements[i].SubModuleName != "" && !raceElements[i].IsParentVisible(gameInfo.UILayers[raceElements[i].ModuleIndex])) ? false : true )) {
            raceElements[i].SetVisible(!raceElements[i].GetVisible());
        }
    }

    UI::Separator();
    UI::Text("\\$9CFTime Attack\\$z");
    for (uint i = 0; i < timeattackElements.Length; i++) {
        if(UI::MenuItem(timeattackElements[i].MenuText(), "", timeattackElements[i].GetVisible(), (timeattackElements[i].SubModuleName != "" && !timeattackElements[i].IsParentVisible(gameInfo.UILayers[timeattackElements[i].ModuleIndex])) ? false : true )) {
            timeattackElements[i].SetVisible(!timeattackElements[i].GetVisible());
        }
    }

    UI::Separator();
    UI::Text("\\$9CFKnockout\\$z");
    for (uint i = 0; i < knockoutElements.Length; i++) {
        if(UI::MenuItem(knockoutElements[i].MenuText(), "", knockoutElements[i].GetVisible(), (knockoutElements[i].SubModuleName != "" && !knockoutElements[i].IsParentVisible(gameInfo.UILayers[knockoutElements[i].ModuleIndex])) ? false : true )) {
            knockoutElements[i].SetVisible(!knockoutElements[i].GetVisible());
        }
    }

    UI::EndMenu();
}

void RenderMenuMain() {
#if TMNEXT
    if (gameInfo.IsPlaying()) {
        if (showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {
            HUDPickerUI();
        }
    }
#endif
}

void RenderMenu() {
#if TMNEXT
    if (gameInfo.IsPlaying()) {
        if (!showMenu && UI::BeginMenu(Icons::Eye + " HUD Picker")) {
            HUDPickerUI();
        }
    }
#endif
}

GameInfo@ gameInfo;

void Main() {
#if TMNEXT
    @gameInfo = GameInfo();

    while(true) {
        // wait until playground finishes loading
        while (gameInfo.LoadProgress.State == NGameLoadProgress_SMgr::EState::Displayed) {
            yield();
        }
        if (gameInfo.IsPlaying()) {
            for (uint i = 0; i < raceElements.Length; i++) {
                if (raceElements[i].ModuleIndex != -1 && raceElements[i].ModuleIndex < int(gameInfo.UILayers.Length)) {
                    auto uilayer = gameInfo.UILayers[raceElements[i].ModuleIndex];
                    raceElements[i].UpdateVisibilty(uilayer);
                    raceElements[i].SetStyle(uilayer);
                    if (raceElements[i].Name == "Chronometer") {
                        cast<ChronoHUDElement@>(raceElements[i]).ClipDigit(gameInfo.UILayers[raceElements[i].ModuleIndex]);
                    }
                } else {
                    raceElements[i].FindElements(gameInfo.UILayers);
                }
            }
            for (uint i = 0; i < timeattackElements.Length; i++) {
                if (timeattackElements[i].ModuleIndex != -1 && timeattackElements[i].ModuleIndex < int(gameInfo.UILayers.Length)) {
                    timeattackElements[i].UpdateVisibilty(gameInfo.UILayers[timeattackElements[i].ModuleIndex]);
                } else {
                    timeattackElements[i].FindElements(gameInfo.UILayers);
                }
            }
            for (uint i = 0; i < knockoutElements.Length; i++) {
                if (knockoutElements[i].ModuleIndex != -1 && knockoutElements[i].ModuleIndex < int(gameInfo.UILayers.Length)) {
                    knockoutElements[i].UpdateVisibilty(gameInfo.UILayers[knockoutElements[i].ModuleIndex]);
                } else {
                    knockoutElements[i].FindElements(gameInfo.UILayers);
                }
            }

            if (hideScissorRect == gameInfo.ScissorRect) {
                gameInfo.ScissorRect = !hideScissorRect;
            }
        }
        yield();
    }
#endif
}