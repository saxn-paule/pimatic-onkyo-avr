// Power
var POWER = {
  "ON": "PWR01",
  "OFF": "PWR00",
  "STATUS": "PWRQSTN"
};

// Audio
var AUDIO = {
  "Mute": "AMT01",
  "UnMute": "AMT00",
  "MuteQstn": "AMTQSTN",
  "Volume Up": "MVLUP",
  "Volume Down": "MVLDOWN",
  "Volume Up1": "MVLUP1",
  "Volume Down1": "MVLDOWN1",
  "Volume": "MVLQSTN"
};

// Source Select
var SOURCE_SELECT = {
  "VIDEO1": "SLI00",
  "CBL/SAT": "SLI01",
  "VIDEO2": "SLI01",
  "GAME": "SLI02",
  "AUX": "SLI03",
  "VIDEO5": "SLI04",
  "PC": "SLI05",
  "VIDEO6": "SLI05",
  "VIDEO7": "SLI06",
  "BD/DVD": "SLI10",
  "TV": "SLI12",
  "TAPE1": "SLI20",
  "TAPE2": "SLI21",
  "PHONO": "SLI22",
  "CD": "SLI23",
  "FM": "SLI24",
  "AM": "SLI25",
  "TUNER": "SLI26",
  "MUSICSERVER": "SLI27",
  "INTERNETRADIO": "SLI28",
  "USB": "SLI29",
  "MULTICH": "SLI30",
  "XM": "SLI31",
  "SIRIUS": "SLI32",
  "USB_REAR": "SLI2A",
  "NET": "SLI2B",
  "USB": "SLI2C",
  "AIRPLAY": "SLI2D",
  "BT": "SLI2E",
  "QSTN": "SLIQSTN",
  "UP": "SLIUP",
  "DOWN": "SLIDOWN"
};
  
// Speaker AB Control
var SPEAKER_AB_CONTROL = {
  "A_OFF": "SPA00",
  "A_ON": "SPA01",
  "B_OFF": "SPB00",
  "B_ON": "SPB01"
};

// Sound modes
var SOUND_MODES = {
  "STEREO": "LMD00",
  "DIRECT": "LMD01",
  "SURROUND": "LMD02",
  "FILM": "LMD03",
  "THX": "LMD04",
  "ACTION": "LMD05",
  "MUSICAL": "LMD06",
  "MONO MOVIE": "LMD07",
  "ORCHESTRA": "LMD08",
  "UNPLUGGED": "LMD09",
  "STUDIO-MIX": "LMD0A",
  "TV LOGIC": "LMD0B",
  "ALL CH STEREO": "LMD0C",
  "THEATER-DIMENSIONAL": "LMD0D",
  "ENHANCED 7/ENHANCE": "LMD0E",
  "MONO": "LMD0F",
  "PURE AUDIO": "LMD11",
  "MULTIPLEX": "LMD12",
  "FULL MONO": "LMD13",
  "DOLBY VIRTUAL": "LMD14",
  "5.1ch Surround": "LMD40",
  "Straight Decode*1": "LMD40",
  "Dolby EX/DTS ES": "LMD41",
  "Dolby EX*2": "LMD41",
  "THX Cinema": "LMD42",
  "THX Surround EX": "LMD43",
  "U2/S2 Cinema/Cinema2": "LMD50",
  "MusicMode": "LMD51",
  "Games Mode": "LMD52",
  "PLII/PLIIx Movie": "LMD80",
  "PLII/PLIIx Music": "LMD81",
  "Neo6 Cinema": "LMD82",
  "Neo6 Music": "LMD83",
  "PLII/PLIIx THX Cinema": "LMD84",
  "Neo6 THX Cinema": "LMD85",
  "PLII/PLIIx Game": "LMD86",
  "Neural Surr*3": "LMD87",
  "Neural THX": "LMD88",
  "PLII THX Games": "LMD89",
  "Neo6 THX Games": "LMD8A",
  "QSTN": "LMDQSTN",
  "UP": "LMDUP",
  "DOWN": "LMDDOWN"
};

var ZONE2_POWER = {
    "ON": "ZPW01",
    "STANDBY": "ZPW00",
    "STATUS": "ZPWQSTN"
};

// Audio
var ZONE2_AUDIO = {
    "MUTE": "ZMT01",
    "UNMUTE": "ZMT00",
    "MUTE_QSTN": "ZMTQSTN",
    "VOL_UP": "ZVLUP",
    "VOL_DOWN": "ZVLDOWN",
    "VOL_UP1": "ZVLUP1",
    "VOL_DOWN1": "ZVLDOWN1",
    "VOL_QSTN": "ZVLQSTN"
};

// Source Select
var ZONE2_SOURCE_SELECT = {
    "CBL/SAT": "SLZ01",
    "GAME": "SLZ02",
    "AUX": "SLZ03",
    "BD/DVD": "SLZ10",
    "STRM_BOX": "SLZ11",
    "TV": "SLZ12",
    "PHONO": "SLZ22",
    "CD": "SLZ23",
    "FM": "SLZ24",
    "AM": "SLZ25",
    "TUNER": "SLZ26",
    "USB_FRONT": "SLZ29",
    "NET": "SLZ2B",
    "USB_REAR": "SLZ2C",
    "BT": "SLZ2E",
    "HDMI_5": "SLZ55",
    "QSTN": "SLZQSTN",
    "UP": "SLZUP",
    "DOWN": "SLZDOWN"
};

// Net commands
var ZONE2_NET = {
    "PLAY": "NTZPLAY",
    "STOP": "NTZSTOP",
    "PAUSE": "NTZPAUSE",
    "PLAY_PAUSE": "NTZP/P",
    "TRACK_UP": "NTZTRUP",
    "TRACK_DOWN": "NTZTRDN",
    "CHANNEL_UP": "NTZCHUP",
    "CHANNEL_DOWN": "NTZCHDN",
    "FF": "NTZFF",
    "REW": "NTZREW",
    "REPEAT": "NTZREPEAT",
    "RANDOM": "NTZRANDOM",
    "REPEAT_SHUFFLE": "NTZREP/SHF",
    "DISPLAY": "NTZDISPLAY",
    "MEMORY": "NTZMEMORY",
    "RIGHT": "NTZRIGHT",
    "LEFT": "NTZLEFT",
    "UP": "NTZUP",
    "DOWN": "NTZDOWN",
    "SELECT": "NTZSELECT",
    "RETURN": "NTZRETURN"
};

var ZONE3_POWER = {
    "ON": "PW301",
    "STANDBY": "PW300",
    "STATUS": "PW3QSTN"
};

// Audio
var ZONE3_AUDIO = {
    "MUTE": "MT301",
    "UNMUTE": "MT300",
    "MUTE_QSTN": "MT3QSTN",
    "VOL_UP": "VL3UP",
    "VOL_DOWN": "VL3DOWN",
    "VOL_UP1": "VL3UP1",
    "VOL_DOWN1": "VL3DOWN1",
    "VOL_QSTN": "VL3QSTN"
};

// Source Select
var ZONE3_SOURCE_SELECT = {
    "CBL/SAT": "SL301",
    "GAME": "SL302",
    "AUX": "SL303",
    "BD/DVD": "SL310",
    "STRM_BOX": "SL311",
    "TV": "SL312",
    "PHONO": "SL322",
    "CD": "SL323",
    "FM": "SL324",
    "AM": "SL325",
    "TUNER": "SL326",
    "USB_FRONT": "SL329",
    "NET": "SL32B",
    "USB_REAR": "SL32C",
    "BT": "SL32E",
    "HDMI_5": "SL355",
    "QSTN": "SL3QSTN",
    "UP": "SL3UP",
    "DOWN": "SL3DOWN"
};

// Net commands
var ZONE3_NET = {
    "PLAY": "NT3PLAY",
    "STOP": "NT3STOP",
    "PAUSE": "NT3PAUSE",
    "PLAY_PAUSE": "NT3P/P",
    "TRACK_UP": "NT3TRUP",
    "TRACK_DOWN": "NT3TRDN",
    "CHANNEL_UP": "NT3CHUP",
    "CHANNEL_DOWN": "NT3CHDN",
    "FF": "NT3FF",
    "REW": "NT3REW",
    "REPEAT": "NT3REPEAT",
    "RANDOM": "NT3RANDOM",
    "REPEAT_SHUFFLE": "NT3REP/SHF",
    "DISPLAY": "NT3DISPLAY",
    "MEMORY": "NT3MEMORY",
    "RIGHT": "NT3RIGHT",
    "LEFT": "NT3LEFT",
    "UP": "NT3UP",
    "DOWN": "NT3DOWN",
    "SELECT": "NT3SELECT",
    "RETURN": "NT3RETURN"
};

var getGroups = function() {
  var groups = [
    'POWER',
    'AUDIO',
    'SOURCE_SELECT',
    'SOUND_MODES',
    'SPEAKER_AB_CONTROL',
    'ZONE2_POWER',
    'ZONE2_AUDIO',
    'ZONE2_SOURCE_SELECT',
    'ZONE2_NET',
    'ZONE3_POWER',
    'ZONE3_AUDIO',
    'ZONE3_SOURCE_SELECT',
    'ZONE3_NET'
  ];
  return groups;
};

var getGroupCommands = function(group) {
  return Object.keys(module.exports[group]);
};

module.exports = {
  DISCOVER: '!xECNQSTN',
  POWER: POWER,
  AUDIO: AUDIO,
  SOURCE_SELECT: SOURCE_SELECT,
  SOUND_MODES: SOUND_MODES,
  SPEAKER_AB_CONTROL: SPEAKER_AB_CONTROL,
  ZONE2_POWER: ZONE2_POWER,
  ZONE2_AUDIO: ZONE2_AUDIO,
  ZONE2_SOURCE_SELECT: ZONE2_SOURCE_SELECT,
  ZONE2_NET: ZONE2_NET,
  ZONE3_POWER: ZONE3_POWER,
  ZONE3_AUDIO: ZONE3_AUDIO,
  ZONE3_SOURCE_SELECT: ZONE3_SOURCE_SELECT,
  ZONE3_NET: ZONE3_NET,
  getGroups: getGroups,
  getGroupCommands: getGroupCommands
};
