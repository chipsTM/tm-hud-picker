# [HUD Picker](https://openplanet.dev/plugin/hudpicker)

![HUD Picker Image](./opfiles/HUD_Picker_v3.png)

## Pick which HUD elements you want to see (DOES NOT work when hide interface enabled)

---

## Features
- Choose which UI elements you wish to see during a race
- Can select options from the settings menu or menubar dropdown

Additional UI elements can be added (contact me on the Openplanet discord)

## Changelog

### v3.3.0
- add missing UI elements (Spectator Name, Medal Banner, Medal Celebration)

### v3.2.1
- fix overlay open logic

### v3.2.0
- adhere to server UI state

### v3.1.1
- fix error

### v3.1.0
- add option to disable HUD Picker when overlay open - titisee5

### v3.0.2
- fix for game update

### v3.0.1
- fix index reset

### v3.0.0
- major refactor of architecture and features
- removed: hide black bars during ghost/replay (this is not needed anymore)

### v2.4.0
- added ability to set color and opacity of chrono/countdown

### v2.3.0
- added setting: Clip last digit off chrono
- added setting: Hide Black Bars during ghost/replay

### v2.2.1
- fix UI stack unwind, only shows dropdown menu during race

### v2.2
- some additional refactor to only store index instead of Nod object. (Hopefully no more crashes)

### v2.1
- add null check in order to prevent game from crashing

### v2.0
- major refactor to set elements as classes and remove repetitive code
- added ability to toggle sub-views (requested by Inspeired and IamPd)
- added option to move dropdown menu location for ease of access

### v1.1
- signed for all users to be able to utilize
- added countdown to hud options

### v1.0
- Initial Release

