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
        if (uiDic[section][i]["children"].Length > 0) {
            for (uint j = 0; j < uiDic[section][i]["children"].Length; j++) {
                uiDic[section][i]["children"][j]["index"] = -1;
                uiDic[section][i]["children"][j]["changed"] = true;
            }
        } else {
            uiDic[section][i]["changed"] = true;
            uiDic[section][i]["index"] = -1;
        }
    }
}

void UpdateVisibility(Json::Value@ obj) {
    if (!bool(obj["changed"])) return;

    array<string> parts = string(obj["controlId"]).Split("|");
    CGameManialinkPage@ Page = gameInfo.NetworkUILayers[uint(obj["index"])].LocalPage;

    if (parts.Length > 1) {
        CGameManialinkControl@ control = Page.GetFirstChild(parts[parts.Length-1]);
        if (control is null) return;
        array<CGameManialinkFrame@> frames = { cast<CGameManialinkFrame@>(control) };
        while (!frames.IsEmpty()) {
            if (bool(obj["visibility"])) {
                frames[0].Show();
            } else {
                frames[0].Hide();
            }
            MwFastBuffer<CGameManialinkControl@> children = frames[0].Controls;
            for (uint i = 0; i < children.Length; i++) {
                if (Reflection::TypeOf(children[i]).Name == "CGameManialinkFrame") {
                    frames.InsertLast(cast<CGameManialinkFrame@>(children[i]));
                } else {
                    if (bool(obj["visibility"])) {
                        children[i].Show();
                    } else {
                        children[i].Hide();
                    }
                }
            }
            frames.RemoveAt(0);
        }
        obj["changed"] = false;
        return;
    }

    auto c = Page.GetFirstChild(parts[0]);
    if (c.ControlId != parts[0]) return;
    if (bool(obj["visibility"])) {
        c.Show();
    } else {
        c.Hide();
    }
    obj["changed"] = false;
}

void UpdateStyle(Json::Value@ obj) {
    if (!obj.HasKey("styles")) return;
    CGameManialinkPage@ Page = gameInfo.NetworkUILayers[uint(obj["index"])].LocalPage;
    auto styleKeys = obj["styles"].GetKeys();
    for (uint i = 0; i < styleKeys.Length; i++) {
        array<string> parts = styleKeys[i].Split(".");
        CGameManialinkControl@ control = Page.GetFirstChild(parts[0]);
        if (parts[1] == "textcolor") {
            CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(control);
            auto val = obj["styles"][styleKeys[i]];
            label.TextColor = vec3(val[0], val[1], val[2]);
        }
    }
}

void IterateSection(const string &in section) {
    for (uint i = 0; i < uiDic[section].Length; i++) {
        if (int(uiDic[section][i]["index"]) == -1) {
            UpdateIndex(uiDic[section][i]);
        }
        if (int(uiDic[section][i]["index"]) == -2) {
            continue;
        }
        UpdateVisibility(uiDic[section][i]);
        UpdateStyle(uiDic[section][i]);

        if (uiDic[section][i]["children"].Length > 0) {
            for (uint j = 0; j < uiDic[section][i]["children"].Length; j++) {
                if (int(uiDic[section][i]["children"][j]["index"]) == -1) {
                    UpdateIndex(uiDic[section][i]["children"][j]);
                }
                if (int(uiDic[section][i]["children"][j]["index"]) == -2) {
                    continue;
                }
                UpdateVisibility(uiDic[section][i]["children"][j]);
            }
        }
    }
}

GameInfo@ gameInfo;
auto plugin = Meta::ExecutingPlugin();
Json::Value@ uiDic = Json::Object();

void OnSettingsSave(Settings::Section& section) {
    auto curSettings = plugin.GetSetting("SerializedData");
    curSettings.WriteString(Json::Write(uiDic));
}

void Main() {
    @gameInfo = GameInfo();

    // Initial settings load 
    auto curSettings = plugin.GetSetting("SerializedData");
    if (curSettings.ReadString() == "") {
        uiDic = Json::FromFile("src/elements.json");
    } else {
        uiDic = Json::Parse(curSettings.ReadString());
    }

    while(true) {
        yield();
        // wait until playground finishes loading
        while (gameInfo.LoadProgress.State == NGameLoadProgress_SMgr::EState::Displayed) {
            yield();
        }
        if (gameInfo.IsPlaying()) {
            IterateSection("Race");
            IterateSection("Knockout");
        } else {
            ResetIndexes("Race");
            ResetIndexes("Knockout");
        }
    }
}