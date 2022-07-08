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

    MwFastBuffer<CGameUILayer@> UILayers {
        get const {
            return this.Network.ClientManiaAppPlayground.UILayers;
        }
    }

    bool IsPlaying() {
        auto network = Network;
        auto playground = CurrentPlayground;
        return playground !is null &&
               network.ClientManiaAppPlayground !is null &&
               network.ClientManiaAppPlayground.Playground !is null &&
               network.ClientManiaAppPlayground.UILayers.Length > 0 &&
               playground.GameTerminals.Length > 0 &&
               playground.GameTerminals[0].UISequence_Current == SGamePlaygroundUIConfig::EUISequence::Playing;
    }

}