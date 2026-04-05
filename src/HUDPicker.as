void UpdateCategory(array<UILayerWrapper@> elements) {
    for (uint i = 0; i < elements.Length; i++) {
        elements[i].UpdateIndex();
        elements[i].UpdateVisibility();
        elements[i].UpdateStyles();

        for (uint j = 0; j < elements[i].SubElements.Length; j++) {
            elements[i].SubElements[j].UpdateIndex();
            elements[i].SubElements[j].UpdateVisibility();
            elements[i].SubElements[j].UpdateStyles();
        }
    }
}

void CEnable() {
    for (uint i = 0; i < Categories.Length; i++) {
        UpdateCategory(Categories[i]);
    }
}

void OnEnabled() {
    CEnable();
}

void ResetCategory(array<UILayerWrapper@> elements) {
    for (uint i = 0; i < elements.Length; i++) {
        elements[i].ResetVisibility();
        elements[i].ResetStyles();
        elements[i].ResetIndex();

        for (uint j = 0; j < elements[i].SubElements.Length; j++) {
            elements[i].SubElements[j].ResetVisibility();
            elements[i].SubElements[j].ResetStyles();
            elements[i].SubElements[j].ResetIndex();
        }
    }
}

void CDisable() {
    for (uint i = 0; i < Categories.Length; i++) {
        ResetCategory(Categories[i]);
    }
}

void OnDisabled() {
    CDisable();
}

void OnDestroyed() {
    CDisable();
}

GameInfo@ gameInfo;
vec2 uiBounds;

void Main() {
    @gameInfo = GameInfo();
    LoadState();

    while(true) {
        yield();

        // determine correct uiBounds
        // default is typically 320x180 centered
        // -160 to 160 width and -90 to 90 height
        float g_w = Display::GetWidth();
        float g_h = Display::GetHeight();
        if (g_w > g_h) {
            uiBounds = vec2(g_w / g_h * 180, 180);
        } else {
            uiBounds = vec2(320, 180);
        }

        while (gameInfo.LoadProgress.State == NGameLoadProgress::EState::Displayed) {
            yield();
        }

        if (gameInfo.InServer()) {
            if (gameInfo.IsPlaying()) {
                if (toggleOverlay && UI::IsOverlayShown()) {
                    CDisable();
                } else {
                    CEnable();
                }
            } else {
                CDisable();
            }
        } else {
            CDisable();
        }
    }
}
