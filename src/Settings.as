// Show in Main Menu Bar
[Setting category="General" name="Show dropdown in Main Menu Bar (otherwise will show under scripts menu)"]
bool showMenu = true;

[Setting category="General" name="Enable Global Color"]
bool enableGlobalColor = false;

[Setting category="General" name="Global Color" color]
vec3 globalColor = vec3(1.0,1.0,1.0);

[Setting category="General" name="Enable Global Opacity"]
bool enableGlobalOpacity = false;

[Setting category="General" name="Global Opacity" min=0.0 max=1.0]
float globalOpacity = 1.0;

[Setting category="General" name="Rainbow Road"]
bool rainbowRoad = false;

[Setting category="General" name="Rainbow Rate" min=0.001 max=0.1]
float rate = 0.001;

[Setting category="General" name="Clip the last digit off chrono"]
bool clipChrono = false;

[Setting category="General" name="Hide black bars during ghost/replay"]
bool hideScissorRect = false;

// Common Race HUD Settings
[Setting category="Race" name="Chronometer" description="Located center bottom"]
bool chronoVisible = true;

[Setting category="Race" name="Chronometer Color" color]
vec3 chronoColor = vec3(1.0,1.0,1.0);

[Setting category="Race" name="Chronometer Opacity" min=0.0 max=1.0]
float chronoOpacity = 1.0;

[Setting category="Race" name="Countdown" description="Located right side screen"]
bool countdownVisible = true;

[Setting category="Race" name="Countdown Color" color]
vec3 countdownColor = vec3(0.9725,0.9725,1.0);

[Setting category="Race" name="Countdown Opacity" min=0.0 max=1.0]
float countdownOpacity = 1.0;

[Setting category="Race" name="Laps Counter" description="Located top right"]
bool lapscounterVisible = true;

[Setting category="Race" name="Records" description="Located left side screen"]
bool recordVisible = true;

[Setting category="Race" name=" Medal Stack" description="Part of Record. Medal stack in top left"]
bool medalstackVisible = true;

[Setting category="Race" name=" Medal Celebration" description="Part of Record. Shows when a new medal is achieved"]
bool medalcelebrationVisible = true;

// [Setting category="Race" name=" Record Table" description="Part of Record. The actual records table"]
bool recordtableVisible = true;

[Setting category="Race" name="Respawn Helper" description="Located right side screen"]
bool respawnhelperVisible = true;

[Setting category="Race" name="Split Times" description="Located center top"]
bool checkpointVisible = true;

[Setting category="Race" name=" Race Time" description="Part of Checkpoint. Shows race time"]
bool racetimeVisible = true;

[Setting category="Race" name=" Race Time Difference" description="Part of Checkpoint. Shows red/blue time difference"]
bool racetimediffVisible = true;

[Setting category="Race" name=" Race Rank" description="Part of Checkpoint. Shows rank"]
bool racerankVisible = true;

[Setting category="Race" name="Time Gap" description="Located top left"]
bool timegapVisible = true;

[Setting category="Race" name="ScoresTableHelper" description=""]
bool scorestablehelperVisible = true;

// Time Attack HUD Settings
[Setting category="Time Attack" name="Best Race Viewer"]
bool bestraceviewerVisible = true;

[Setting category="Time Attack" name="End Match Trophy"]
bool endmatchtrophyVisible = true;

/*
[Setting category="Time Attack" name="Daily TA Tracker"]
bool dailytatrackerVisible = true;

[Setting category="Time Attack" name="Daily Next Match Tracker"]
bool dailynextmatchtrackerVisible = true;

*/


// Knockout HUD Settings
[Setting category="Knockout" name="Knockout Info" description="Located left side screen"]
bool knockoutinfoVisible = true;

// [Setting category="Knockout" name="Knockout Reward"]
// bool knockoutrewardVisible = true;

// [Setting category="Knockout" name="Knocked Out Players"]
// bool knockedoutplayersVisible = true;

// [Setting category="Knockout" name="Elimination Warning"]
// bool eliminationwarningVisible = true;

// [Setting category="Knockout" name="Daily Welcome PopUp"]
// bool dailywelcomepopupVisible = true;