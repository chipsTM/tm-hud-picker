void UpdateIndex(Json::Value@ obj) {
    array<string> parts = string(obj["controlId"]).Split("|");
    for (uint i = 0; i < gameInfo.NetworkUILayers.Length; i++) {
        CGameManialinkControl@ control = gameInfo.NetworkUILayers[i].LocalPage.GetFirstChild(parts[0]);
        if (control !is null) {
            obj["index"] = i;
            return;
        } else {
            continue;
        }
    }
    obj["index"] = -2;
}

void ResetIndexes(const string &in section) {
    for (uint i = 0; i < uiDic[section].Length; i++) {
        uiDic[section][i]["changed"] = true;
        uiDic[section][i]["index"] = -1;

        if (uiDic[section][i]["children"].Length > 0) {
            for (uint j = 0; j < uiDic[section][i]["children"].Length; j++) {
                uiDic[section][i]["children"][j]["index"] = -1;
                uiDic[section][i]["children"][j]["changed"] = true;
            }
        }
    }
}

void UpdateVisibility(Json::Value@ obj, int status) {
    if (!bool(obj["changed"])) return;

    array<string> parts = string(obj["controlId"]).Split("|");
    CGameManialinkPage@ Page = gameInfo.NetworkUILayers[uint(obj["index"])].LocalPage;

    if (parts.Length > 1) {
        CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
        if (control is null) return;
        array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
        while (!frames.IsEmpty()) {
            if (status == -1) {
                frames[0].Show();
            } else {
                if (bool(obj["visibility"])) {
                    frames[0].Show();
                } else {
                    frames[0].Hide();
                }
            }
            MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
            for (uint i = 0; i < children.Length; i++) {
                if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                    frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                } else {
                    if (status == -1) {
                        children[i].Show();
                    } else {
                        if (bool(obj["visibility"])) {
                            children[i].Show();
                        } else {
                            children[i].Hide();
                        }
                    }
                }
            }
            frames.RemoveAt(0);
        }
        obj["changed"] = false;
        return;
    }

    auto c = Page.GetFirstChild(parts[0]);
    if (c is null) return;
    if (c.ControlId != parts[0]) return;
    if (status == -1) {
        c.Show();
    } else {
        if (bool(obj["visibility"])) {
            c.Show();
        } else {
            c.Hide();
        }
    }
    obj["changed"] = false;
}

void UpdateStyles(Json::Value@ obj, int status) {
    if (!obj.HasKey("styles")) return;
    if (string(obj["controlId"]) == "Race_Chrono") ChronoStyles(obj, status);
}

void IterateSection(const string &in section, int status) {
    for (uint i = 0; i < uiDic[section].Length; i++) {
        if (int(uiDic[section][i]["index"]) == -1) {
            UpdateIndex(uiDic[section][i]);
        }
        if (int(uiDic[section][i]["index"]) == -2) {
            continue;
        }
        if (status != 0) {
            uiDic[section][i]["changed"] = true;
        }
        UpdateVisibility(uiDic[section][i], status);
        UpdateStyles(uiDic[section][i], status);

        if (uiDic[section][i]["children"].Length > 0) {
            for (uint j = 0; j < uiDic[section][i]["children"].Length; j++) {
                if (int(uiDic[section][i]["children"][j]["index"]) == -1) {
                    UpdateIndex(uiDic[section][i]["children"][j]);
                }
                if (int(uiDic[section][i]["children"][j]["index"]) == -2) {
                    continue;
                }
                if (status != 0) {
                    uiDic[section][i]["children"][j]["changed"] = true;
                }
                UpdateVisibility(uiDic[section][i]["children"][j], status);
            }
        }
    }
}

GameInfo@ gameInfo;
auto plugin = Meta::ExecutingPlugin();
Json::Value@ uiDic = Json::Object();

void OnSettingsSave(Settings::Section& section) {
    Json::ToFile(IO::FromStorageFolder("settings.json"), uiDic);
}

void SetVis(int val) {
    if (gameInfo.IsPlaying()) {
        IterateSection("Race", val);
        IterateSection("Knockout", val);
    }
}

void OnEnabled() {
    SetVis(1);
}

void OnDisabled() {
    SetVis(-1);
}

void OnDestroyed() {
    SetVis(-1);
}

bool prev_isOverlayShown = false;

void Main() {
    @gameInfo = GameInfo();

    // Initial settings load
    auto curSettings = Json::FromFile(IO::FromStorageFolder("settings.json"));
    if (curSettings.GetType() == Json::Type::Null) {
        uiDic = Json::Parse(elementsJson);
        // uiDic = Json::FromFile("src/elements.json");
        Json::ToFile(IO::FromStorageFolder("settings.json"), uiDic);
    } else {
        uiDic = curSettings;
    }
    // load current state
    SetVis(1);

    while(true) {
        yield();
        // wait until playground finishes loading
        while (gameInfo.LoadProgress.State == NGameLoadProgress_SMgr::EState::Displayed) {
            yield();
        }
        if (toggleInterface && UI::IsOverlayShown() != prev_isOverlayShown) {
            prev_isOverlayShown = UI::IsOverlayShown();
            if (prev_isOverlayShown) {
                OnDisabled();
            } else {
                OnEnabled();
            }
        }
        if (gameInfo.IsPlaying()) {
            IterateSection("Race", 0);
            IterateSection("Knockout", 0);
        } else {
            ResetIndexes("Race");
            ResetIndexes("Knockout");
        }
    }
}