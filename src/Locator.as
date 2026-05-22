vec2 g_mouse;
bool IsDotPressed;
bool LocatorLock = false;

void Render() {
    if (!LocatorMode) return;
    IsDotPressed = UI::IsKeyDown(UI::Key::Period);
    for (uint i = 0; i < Categories.Length; i++) {
        for (uint j = 0; j < Categories[i].Length; j++) {
            Categories[i][j].Locator(g_mouse);
        }
    }
    g_mouse = UI::GetMousePos();
    LocatorMode = false;
}

enum HAlign {
    Left,
    Center,
    Right,
}

enum VAlign {
    Top,
    Center,
    Bottom,
}

vec4 MLRectToScreen(vec2 start, vec2 size, HAlign halign, VAlign valign) {
    float screenStartX;
    float screenStartY;
    float screenSizeX = size.x * xScale;
    float screenSizeY = size.y * yScale;

    if (halign == HAlign::Left) {
        screenStartX = (start.x + uiBounds.x / 2) * xScale;
    } else if (halign == HAlign::Center) {
        screenStartX = ((start.x + uiBounds.x / 2) * xScale) - screenSizeX/2;
    } else if (halign == HAlign::Right) {
        screenStartX = (start.x + uiBounds.x / 2) * xScale - screenSizeX;
    }

    if (valign == VAlign::Top) {
        screenStartY = (-start.y + uiBounds.y / 2) * yScale;
    } else if (valign == VAlign::Center) {
        screenStartY = ((-start.y + uiBounds.y / 2) * yScale) - screenSizeY/2;
    } else if (valign == VAlign::Bottom) {
        screenStartY = (-start.y + uiBounds.y / 2) * yScale - screenSizeY;
    }

    return vec4(screenStartX, screenStartY, screenSizeX, screenSizeY);
}

bool GetDragState(vec4 calcSize, vec2 newMouse, bool dragging) {
    if (!UI::IsKeyDown(UI::Key::Period)) return false;
    bool IsDragging = dragging;
    if (InBounds(calcSize, newMouse)) {
        if (UI::IsMouseDown()) {
            if (!LocatorLock) {
                IsDragging = true;
                LocatorLock = true;
            }
        } else {
            IsDragging = false;
        }
    } else {
        if (!UI::IsMouseDown()) {
            IsDragging = false;
            LocatorLock = false;
        }
    }
    return IsDragging;
}

void DrawBounds(vec4 rect, const string &in text) {
    nvg::BeginPath();
    nvg::StrokeColor(vec4(1, 0, 0, 1));
    nvg::StrokeWidth(3);
    nvg::Rect(rect.xy, rect.zw);
    nvg::FillColor(vec4(1, 0, 0, 1));
    nvg::FontSize(20);
    nvg::Text(rect.x, rect.y - 5, text);
    nvg::Stroke();
    nvg::ClosePath();
}

void HighlightBounds(vec4 rect) {
    nvg::BeginPath();
    nvg::StrokeColor(vec4(1, 1, 0, 1));
    nvg::StrokeWidth(3);
    nvg::Rect(rect.xy, rect.zw);
    nvg::Stroke();
    nvg::ClosePath();
}

bool InBounds(vec4 calcSize, vec2 newMouse) {
    if (calcSize.x < newMouse.x && calcSize.y < newMouse.y && (calcSize.x + calcSize.z) > newMouse.x && (calcSize.y + calcSize.w) > newMouse.y) {
        return true;
    } else {
        return false;
    }
}

vec2 ClampBounds(vec2 RectPos, vec2 RectSize, HAlign halign, VAlign valign) {
    float clampMaxX, clampMinX, clampMaxY, clampMinY;

    if (halign == HAlign::Left) {
        clampMaxX = uiBounds.x / 2 - RectSize.x;
        clampMinX = -uiBounds.x / 2;
    } else if (halign == HAlign::Center) {
        clampMaxX = uiBounds.x / 2 - RectSize.x / 2;
        clampMinX = -uiBounds.x / 2 + RectSize.x / 2;
    } else if (halign == HAlign::Right) {
        clampMaxX = uiBounds.x / 2;
        clampMinX = -uiBounds.x / 2 + RectSize.x;
    }

    if (valign == VAlign::Top) {
        clampMaxY = uiBounds.y / 2;
        clampMinY = -uiBounds.y / 2 + RectSize.y;
    } else if (valign == VAlign::Center) {
        clampMaxY = uiBounds.y / 2 - RectSize.y / 2;
        clampMinY = -uiBounds.y / 2 + RectSize.y / 2;
    } else if (valign == VAlign::Bottom) {
        clampMaxY = uiBounds.y / 2 - RectSize.y;
        clampMinY = -uiBounds.y / 2;
    }

    if (RectPos.x >= clampMaxX) {
        RectPos.x = clampMaxX;
    } else if (RectPos.x <= clampMinX) {
        RectPos.x = clampMinX;
    }

    if (RectPos.y >= clampMaxY) {
        RectPos.y = clampMaxY;
    } else if (RectPos.y <= clampMinY) {
        RectPos.y = clampMinY;
    }

    return RectPos;
}