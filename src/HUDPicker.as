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

void IterateCategory(array<UILayerWrapper@> elements) {
    for (uint i = 0; i < elements.Length; i++) {
        if (elements[i].Index == IndexStatus::NeedsUpdate) {
            elements[i].UpdateIndex();
        }
        if (elements[i].Index == IndexStatus::NotFound) {
            continue;
        }

        elements[i].UpdateVisibility();
        elements[i].UpdateStyles();

        for (uint j = 0; j < elements[i].SubElements.Length; j++) {
            if (elements[i].SubElements[j].Index == IndexStatus::NeedsUpdate) {
                elements[i].SubElements[j].UpdateIndex();
            }
            if (elements[i].SubElements[j].Index == IndexStatus::NotFound) {
                continue;
            }
            elements[i].SubElements[j].UpdateVisibility();
            elements[i].SubElements[j].UpdateStyles();
        }
    }
}

void CEnable() {
    for (uint i = 0; i < Categories.Length; i++) {
        IterateCategory(Categories[i]);
    }
}

void CDisable() {
    for (uint i = 0; i < Categories.Length; i++) {
        ResetCategory(Categories[i]);
    }
}

void OnEnabled() {
    CEnable();
}

void OnDisabled() {
    CDisable();
}

void OnDestroyed() {
    CDisable();
}

GameInfo@ gameInfo;

void Main() {
    @gameInfo = GameInfo();
    LoadState();

    while(true) {
        yield();
        // wait until playground finishes loading
        while (gameInfo.LoadProgress.State == NGameLoadProgress::EState::Displayed) {
            yield();
        }
        if (gameInfo.IsPlaying()) {
            if (toggleOverlay) {
                if (UI::IsOverlayShown()) {
                    CDisable();
                } else {
                    CEnable();
                }
            } else {
                CEnable();
            }
        } else {
            CDisable();
        }
    }
}
