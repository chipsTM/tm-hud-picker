class GameInfo {
    CTrackMania@ app;

    GameInfo() {
        @app = cast<CTrackMania@>(GetApp());
    }

    CTrackManiaNetwork@ Network {
        get const {
            return cast<CTrackManiaNetwork>(this.app.Network);
        }
        // set {}
    }

    CGamePlayground@ CurrentPlayground {
        get const {
            return cast<CGamePlayground>(this.app.CurrentPlayground);
        }
        // set {}
    }

    NGameLoadProgress_SMgr@ LoadProgress {
        get const {
            return cast<NGameLoadProgress_SMgr>(this.app.LoadProgress);
        }
        // set {}
    }

    MwFastBuffer<CGameUILayer@> NetworkUILayers {
        get const {
            return this.Network.ClientManiaAppPlayground.UILayers;
        }
        // set {}
    }

    CControlFrame@ ClientManialinkPage {
        get const {
            return cast<CGamePlayground@>(cast<CSmArenaClient@>(this.CurrentPlayground).Arena).Interface.ManialinkPage;
        }
        // set {}
    }

    bool IsPlaying() {
        auto network = Network;
        auto playground = CurrentPlayground;
        if (playground !is null && network.ClientManiaAppPlayground !is null && network.ClientManiaAppPlayground.Playground !is null) {
            if (network.ClientManiaAppPlayground.UILayers.Length > 0 && network.ClientManiaAppPlayground.UILayers.Length == layerCount) {
                return true;
            } else {
                layerCount = network.ClientManiaAppPlayground.UILayers.Length;
                return false;
            }
        } else {
            return false;
        }
    }
}
