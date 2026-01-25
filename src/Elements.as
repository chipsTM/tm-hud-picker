uint layerCount = 0;
array<UILayerWrapper@> Race = {
    ChronoUILayer("Race_Chrono", "Chrono", "chrono at bottom of screen"),
    UILayerWrapper("Race_RespawnHelper", "Respawn Helper", "appears after some time when car standing still"),
    UILayerWrapper("Race_Checkpoint", "Checkpoint", "checkpoint info",
        {
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-race|frame-race-time", "Race Time", ""),
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-race|frame-race-diff", "Race Diff", ""),
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-race|frame-race-rank", "Race Rank", ""),
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-lap|frame-lap-time", "Lap Time", ""),
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-lap|frame-lap-diff", "Lap Diff", ""),
        UILayerWrapper("Race_Checkpoint|frame-checkpoint|frame-lap|frame-lap-legend", "Lap Legend", ""),
        }
    ),
    UILayerWrapper("Race_LapsCounter", "Laps Counter", "located top right on a multi-lap race"),
    UILayerWrapper("Race_TimeGap", "Time Gap", "time gap bottom right showing diff between players"),
    UILayerWrapper("Race_ScoresTable", "Scores Table", "shown when holding tab"),
    UILayerWrapper("Race_DisplayMessage", "Display Message", "unknown location (missing context)"),
    UILayerWrapper("Race_Countdown", "Countdown", "countdown on an online server"),
    UILayerWrapper("clip-medal-banner", "Medal Banner", "medals top left"),
    UILayerWrapper("frame-celebration", "Celebration Frame", "medal celebration"),
    UILayerWrapper("Race_Record", "Records", "records table on left"),
    UILayerWrapper("Race_BigMessage", "Big Message", "unknown location (missing context)"),
    UILayerWrapper("Race_BlockHelper", "Block Helper", "block effect messages"),
    UILayerWrapper("Race_WarmUp", "Warm Up", "unknown location (missing context)"),
    UILayerWrapper("Race_VoiceChat", "Voice Chat", "unknown location (missing context)"),
    UILayerWrapper("Race_PrestigeEarned", "Prestige Earned", "prestige earned screen"),
    UILayerWrapper("Race_LoadingScreen", "Loading Screen", "unknown location (missing context)"),
    UILayerWrapper("Race_BestRaceViewer", "Best Race Viewer", "best times on right"),
    UILayerWrapper("Race_SpectatorBase_Commands", "Spectator Base Commands", "unknown location (missing context)"),
    UILayerWrapper("Race_SpectatorBase_Name", "Spectator Base Name", "unknown location (missing context)"),
};
array<UILayerWrapper@> Knockout = {};
array<UILayerWrapper@> COTD = {
    UILayerWrapper("COTDQualifications_Progress", "COTD Progress", "progress of the COTD appears at start and end of qualifying"),
    UILayerWrapper("COTDQualifications_Ranking", "COTD Rankings", "the ranking window of COTD"),
};
array<array<UILayerWrapper@>> Categories = {Race, Knockout, COTD};
