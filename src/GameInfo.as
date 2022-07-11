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
        // set {}
    }

    bool ScissorRect {
        get const {
            if (this.app.Viewport.Cameras.Length > 0) {
                return this.app.Viewport.Cameras[0].ScissorRect;
            }
            // Should never reach here, but we just return the opposite value of
            // global setting so that update doesn't get triggered in main loop
            return !hideScissorRect;
        }
        set {
            if (this.app.Viewport.Cameras.Length > 0) {
                this.app.Viewport.Cameras[0].ScissorRect = value;
            }
        }
    }

    bool IsPlaying() {
        auto network = Network;
        auto playground = CurrentPlayground;
        return playground !is null &&
               network.ClientManiaAppPlayground !is null &&
               network.ClientManiaAppPlayground.Playground !is null &&
               network.ClientManiaAppPlayground.UILayers.Length > 0;
            //    playground.GameTerminals.Length > 0 &&
            //    playground.GameTerminals[0].UISequence_Current == SGamePlaygroundUIConfig::EUISequence::Playing;
    }

}