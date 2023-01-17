array<HUDElement@> raceElements = {
    chrono,
    countdown,
    lapscounter,
    record,
    medalstack,
    medalcelebration,
    // recordtable, currently has issues with the spinners, might need to provide an exclusion clause
    respawnhelper,
    checkpoint,
    racetime,
    racetimediff,
    racerank,
    timegap
    // scorestablehelper only shows 50 times then disappears
};

array<HUDElement@> timeattackElements = {
    bestraceviewer,
    endmatchtrophy
    // Not sure if these should be included as could impact UX, but leave these here incase we need them down the road

//     //HUDElement("Daily TA Tracker", "UIModule_TimeAttackDaily_DailyTrackerTA"),
//     //HUDElement("Daily Next Match Tracker", "UIModule_TimeAttackDaily_NextMatchTracker")
};

array<HUDElement@> knockoutElements = {
    knockoutinfo
    // Not sure if these should be included as could impact UX, but leave these here incase we need them down the road
    
//     //HUDElement("Knockout Reward", "UIModule_Knockout_KnockoutReward"),
//     //HUDElement("Knocked Out Players", "UIModule_Knockout_KnockedOutPlayers"),
//     //HUDElement("Elimination Warning", "UIModule_Knockout_EliminationWarning"),
//     //HUDElement("Daily Welcome PopUp", "UIModule_KnockoutDaily_WelcomePopUp")
};