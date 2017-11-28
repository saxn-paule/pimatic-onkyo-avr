# Description
### This plugin let you control your Onkyo or Pioneer (2016+) AVR via pimatic

# Action
The provided action is called "**sendOnkyo**".

# Sensor
The provided sensor class is:
* OnkyoSensor

## Sensor attributes
Possible attributes are:
* volume
* source
* sound

# Commands
### sendCommand
Has to be used in the following syntax:
```
[action] "[group].[command]"
```
Sample:
*Power the AVR on*
```
sendOnkyo "POWER.ON"
```

*Switch the AVR off*
```
sendOnkyo "POWER.OFF"
```

## Supported commands
*handling the volume*
* VOLUME.DOWN
* VOLUME.UP
* VOLUME.MUTE
* VOLUME.UNMUTE

*getting the current volume*
* AUDIO.Volume

*handling power status*
* POWER.ON
* POWER.OFF
* POWER.STATUS

*handling the input*
* SOURCE_SELECT.VIDEO1
* SOURCE_SELECT.VIDEO2
* SOURCE_SELECT.CBL/SAT
* SOURCE_SELECT.GAME
* SOURCE_SELECT.AUX
* SOURCE_SELECT.VIDEO5
* SOURCE_SELECT.PC
* SOURCE_SELECT.VIDEO6
* SOURCE_SELECT.VIDEO7
* SOURCE_SELECT.BD/DVD
* SOURCE_SELECT.TAPE1
* SOURCE_SELECT.TAPE2
* SOURCE_SELECT.PHONO
* SOURCE_SELECT.CD
* SOURCE_SELECT.FM
* SOURCE_SELECT.AM
* SOURCE_SELECT.TUNER
* SOURCE_SELECT.MUSICSERVER
* SOURCE_SELECT.INTERNETRADIO
* SOURCE_SELECT.USB
* SOURCE_SELECT.MULTICH
* SOURCE_SELECT.XM
* SOURCE_SELECT.SIRIUS
* SOURCE_SELECT.NET
* SOURCE_SELECT.USB
* SOURCE_SELECT.AIRPLAY
* SOURCE_SELECT.BT
* SOURCE_SELECT.QSTN

*change the listening mode*
* SOUND_MODES.STEREO
* SOUND_MODES.DIRECT
* SOUND_MODES.SURROUND
* SOUND_MODES.FILM
* SOUND_MODES.THX
* SOUND_MODES.ACTION
* SOUND_MODES.MUSICAL
* SOUND_MODES.MONO MOVIE
* SOUND_MODES.ORCHESTRA
* SOUND_MODES.UNPLUGGED
* SOUND_MODES.STUDIO-MIX
* SOUND_MODES.TV LOGIC
* SOUND_MODES.ALL CH STEREO
* SOUND_MODES.THEATER-DIMENSIONAL
* SOUND_MODES.ENHANCED 7/ENHANCE
* SOUND_MODES.MONO
* SOUND_MODES.PURE AUDIO
* SOUND_MODES.MULTIPLEX
* SOUND_MODES.FULL MONO
* SOUND_MODES.DOLBY VIRTUAL
* SOUND_MODES.5.1ch Surround
* SOUND_MODES.Straight Decode*1
* SOUND_MODES.Dolby EX/DTS ES
* SOUND_MODES.Dolby EX*2
* SOUND_MODES.THX Cinema
* SOUND_MODES.THX Surround EX
* SOUND_MODES.U2/S2 Cinema/Cinema2
* SOUND_MODES.MusicMode
* SOUND_MODES.Games Mode
* SOUND_MODES.PLII/PLIIx Movie
* SOUND_MODES.PLII/PLIIx Music
* SOUND_MODES.Neo6 Cinema
* SOUND_MODES.Neo6 Music
* SOUND_MODES.PLII/PLIIx THX Cinema
* SOUND_MODES.Neo6 THX Cinema
* SOUND_MODES.PLII/PLIIx Game
* SOUND_MODES.Neural Surr*3
* SOUND_MODES.Neural THX
* SOUND_MODES.PLII THX Games
* SOUND_MODES.Neo6 THX Games
* SOUND_MODES.Listening Mode Wrap-Around Up
* SOUND_MODES.Listening Mode Wrap-Around Down

# Configuration
There is only one (self explaining) configuration parameter
* ip

### Sample Plugin Config:
```javascript
{
  "plugin": "onkyo-avr"
}
```

### Sample Device Config:
```javascript
{
  "class": "OnkyoDevice",
  "ip": "192.168.0.15",
  "id": "vsx-831",
  "name": "VSX-831"
}
```

### Sample Sensor Config:
```javascript
{
  "class": "OnkyoSensor",
  "id": "avrsensor",
  "name": "Display",
  "attributes": [
    {
      "name": "volume"
    },
    {
      "name": "sound"
    },
    {
      "name": "source"
    }
  ],
  "xAttributeOptions": [
    {
      "name": "volume",
      "displaySparkline": false,
      "hidden": false
    }
  ]
}
```

# Beware
This plugin is in an early alpha stadium and you use it on your own risk.
I'm not responsible for any possible damages that occur on your health, hard- or software.

# License
MIT
