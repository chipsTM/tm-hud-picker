void ChronoStyles(Json::Value@ obj) {
    CGameManialinkPage@ Page = gameInfo.NetworkUILayers[uint(obj["index"])].LocalPage;
    CGameManialinkFrame@ frame = cast<CGameManialinkFrame@>(Page.GetFirstChild("frame-chrono"));
    CGameManialinkLabel@ label = cast<CGameManialinkLabel@>(Page.GetFirstChild("label-chrono"));
    if (frame is null || label is null) return;
    if (bool(obj["styles"]["label-chrono"]["rainbow_enabled"])) {
        auto i = float(obj["styles"]["label-chrono"]["rainbow_val"]);
        if (i > 1.0) {
            i = 0.0;
        }
        vec4 newColor = UI::HSV(i, 1.0, 1.0);
        label.TextColor = vec3(newColor.x, newColor.y, newColor.z);
        i += float(obj["styles"]["label-chrono"]["rainbow_rate"]);
        obj["styles"]["label-chrono"]["rainbow_val"] = i;
    } else {
        auto val = obj["styles"]["label-chrono"]["textcolor"];
        label.TextColor = vec3(val[0], val[1], val[2]);
    }
    
    float textWidth = label.ComputeWidth(label.Value);
    float lastdigitWidth = 0;
    if (label.Value.Length > 0) {
        lastdigitWidth = label.ComputeWidth(label.Value.SubStr(label.Value.Length-1, 1));
    }
    if (Regex::Contains(label.Value, "\\.\\d{3}")) {
        frame.ClipWindowActive = false;
        frame.ClipWindowSize = vec2(0,0);
        frame.RelativePosition_V3 = vec2(0,0);
        label.RelativePosition_V3 = vec2(0,0);
    } else {
        if (bool(obj["styles"]["label-chrono"]["clip_digit"])) {
            frame.ClipWindowActive = true;
            frame.ClipWindowSize = vec2(textWidth, label.Size.y+1);
            frame.RelativePosition_V3 = vec2(-lastdigitWidth/2,0);
            label.RelativePosition_V3 = vec2(lastdigitWidth,0);
        } else {
            frame.ClipWindowActive = false;
            frame.ClipWindowSize = vec2(0,0);
            frame.RelativePosition_V3 = vec2(0,0);
            label.RelativePosition_V3 = vec2(0,0);
        }
    }
}

void ChronoStylesSettings(Json::Value@ obj) {
    auto val = obj["styles"]["label-chrono"]["textcolor"];
    vec3 curColor = vec3(val[0], val[1], val[2]);
    vec3 newColor = UI::InputColor3("Text Color", curColor);
    if (curColor != newColor) {
        obj["styles"]["label-chrono"]["textcolor"][0] = newColor.x;
        obj["styles"]["label-chrono"]["textcolor"][1] = newColor.y;
        obj["styles"]["label-chrono"]["textcolor"][2] = newColor.z;
    }
    obj["styles"]["label-chrono"]["rainbow_enabled"] = UI::Checkbox("Rainbow", bool(obj["styles"]["label-chrono"]["rainbow_enabled"]));
    obj["styles"]["label-chrono"]["rainbow_rate"] = UI::SliderFloat("Rainbow Rate", float(obj["styles"]["label-chrono"]["rainbow_rate"]), 0.001, 0.1);
    obj["styles"]["label-chrono"]["clip_digit"] = UI::Checkbox("Clip Digit", bool(obj["styles"]["label-chrono"]["clip_digit"]));
}