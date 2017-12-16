module.exports = (env) ->

	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
	_ = require 'lodash'
	M = env.matcher
	t = env.require('decl-api').types
	Onkyo = require('./lib/onkyo.js/onkyo.js')

	class OnkyoAvrPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>

			deviceConfigDef = require("./device-config-schema")

			@framework.deviceManager.registerDeviceClass("OnkyoAvrDevice",{
				configDef : deviceConfigDef.OnkyoAvrDevice,
				createCallback : (config, lastState) => new OnkyoAvrDevice(config, lastState, this )
			})

			@framework.ruleManager.addActionProvider(new SendCommandActionProvider(@framework))

	class OnkyoAvrDevice extends env.devices.Device
		attributes:
			ip:
				description: 'the AVRs IP address'
				type: t.string
			volume:
				description: 'the AVRs volume'
				type: t.number
				unit: "dB"
			sound:
				description: 'the current sound setting'
				type: t.string
			source:
				description: 'the current source'
				type: t.string
			mute:
				description: 'the mute state'
				type: t.string

		actions:
			turnOn:
				description: "Turns the switch on"
			turnOff:
				description: "Turns the switch off"
			changeStateTo:
				description: "Changes the switch to on or off"
				params:
					state:
						type: t.boolean
			sendCommand:
				description: 'The command to send to the Onkyo AVR'
				params:
					command:
						type: t.string


		constructor: (@config, @plugin, lastState) ->
			@id = @config.id
			@name = @config.name
			@ip = @config.ip or "192.168.0.15"
			@interval = @config.interval || 2000
			@power = "off"
			@onkyoClient = null
			@connected = false

			@volume = lastState?["volume"]?.value or -100
			@display = lastState?["display"]?.value or ""
			@mute = lastState?["mute"]?.value or false
			@source = lastState?["source"]?.value or ""
			@sound = lastState?["sound"]?.value or ""

			@init()

			@onkyoClient.Connect =>
				return

			@onkyoClient.on 'error', (err) =>
				if err
					if err.code is "ETIMEDOUT" or err.code is "EHOSTUNREACH"
						env.logger.warn "Cannot connect to " + err.address + ":" + err.port
						@connected = false
					else if err.code is "ECONNRESET"
						env.logger.warn "Connection to avr device was lost!"
						@connected = false
					else
						env.logger.warn "an unknow error occured:"
						env.logger.error err

				return

			@onkyoClient.on 'detected', (device) =>
				env.logger.info "device: " + device
				return

			@onkyoClient.on 'connected', (host) =>
				env.logger.info 'connected to: ' + JSON.stringify(host)
				@connected = true

			@onkyoClient.on 'msg', (msg) =>
				@parseMessage(msg)
				return

			updateValue = =>
				if @interval > 0
					@_updateValueTimeout = null
					@_getUpdatedDisplay().finally( =>
						@_getUpdatedVolume().finally( =>
							@_getUpdatedMute().finally( =>
								@_getUpdatedSource().finally( =>
									@_getUpdatedSound().finally( =>
										@_updateValueTimeout = setTimeout(updateValue, @interval)
									)
								)
							)
						)
					)

			super()
			updateValue()

		# Returns a promise
		turnOn: ->
			@changeStateTo("on")

		# Returns a promise
		turnOff: ->
			@changeStateTo("off")

		# Returns a promise that is fulfilled when done.
		changeStateTo: (state) ->
			switch state
				when 'on'
					@onkyoClient.PwrOn (error, ok) ->
						if error?
							env.logger.error error
						if ok?
							@power = "on"
						return
				when 'off'
					@onkyoClient.PwrOff (error, ok) ->
						if error?
							env.logger.error error
						if ok?
							@power = "off"
						return

		getIp: -> Promise.resolve(@ip)

		setIp: (value) ->
			if @ip is value then return
			@ip = value

		getInterval: -> Promise.resolve(@interval)

		setInterval: (value) ->
			if @interval is value then return
			@interval = value

		getVolume: ->
			if @volume? then Promise.resolve(@volume)
			else @_getUpdatedVolume("volume")

		getDisplay: ->
			if @display? then Promise.resolve(@display)
			else @_getUpdatedDisplay("display")

		getMute: ->
			if @mute? then Promise.resolve(@mute)
			else @_getUpdatedMute("mute")

		getSource: ->
			if @source? then Promise.resolve(@source)
			else @_getUpdatedSource("source")

		getSound: ->
			if @sound? then Promise.resolve(@sound)
			else @_getUpdatedSound("sound")

		_getUpdatedVolume: () =>
			if not @volume? or @volume is -100
				if @connected
					@sendCommand("AUDIO.Volume")
			else
				@emit "volume", @volume

			return Promise.resolve @volume

		_getUpdatedDisplay: () =>
			@emit "display", @display
			return Promise.resolve @display

		_getUpdatedMute: () =>
			if not @mute? or @mute is ""
				if @connected
					@sendCommand("AUDIO.MuteQstn")
			else
				@emit "mute", @mute

			return Promise.resolve @mute

		_getUpdatedSource: () =>
			if not @source? or @source is ""
				if @connected
					@sendCommand("SOURCE_SELECT.QSTN")
			else
				@emit "source", @source

			return Promise.resolve @source

		_getUpdatedSound: () =>
			if not @sound? or @sound is ""
				if @connected
					@sendCommand("SOUND_MODES.QSTN")
			else
				@emit "sound", @sound

			return Promise.resolve @sound

		parseMessage: (msg) ->
			if typeof msg isnt 'object'
				message = JSON.parse(msg)
			else
				message = msg

			if message.hasOwnProperty 'PWR'
				@power = message["PWR"]

			if message.hasOwnProperty 'MUTE'
				@mute = message["MUTE"]

			if message.hasOwnProperty 'MVL'
				@volume = message["MVL"]/2 - 82

			if message.hasOwnProperty 'MUTE'
				@mute = message["MUTE"]

			if message.hasOwnProperty 'LMD'
				@sound = message["LMD"]

			if message.hasOwnProperty 'SLI'
				@source = message["SLI"]

		init: ->
			env.logger.info "initializing new Onkyo client..."
			@onkyoClient = Onkyo.init(
				log: false
				ip: @ip)

		connect: ->
			if not @connected? or !@connected
				if @onkyoClient?
					@onkyoClient.Connect ->
						@connected = true
						return
				else
					@init()

		disconnect: ->
			if @connected
				@onkyoClient.Close ->
					@connected = false
					return

		powerStatus: ->
			@sendCommand("POWER.STATUS")

		setSource: (src) ->
			if not @connected? or !@connected
				@connect()
			else
				@onkyoClient.SetSource(src, cb) ->
					return

		sendCommand: (command) ->
			if not @connected? or !@connected
				@connect()

			switch command
				when 'POWER.ON'
					@changeStateTo("on")
				when 'POWER.OFF'
					@changeStateTo("off")
				when 'POWER.STATUS'
					@powerStatus()
				when 'VOLUME.MUTE'
					@changeVolume("mute")
				when 'VOLUME.UNMUTE'
					@changeVolume("unmute")
				when 'VOLUME.TOGGLEMUTE'
					if not @mute
						@changeVolume("mute")
					else
						@changeVolume("unmute")
				when 'VOLUME.UP'
					@changeVolume("up")
				when 'VOLUME.DOWN'
					@changeVolume("down")
				else
					@onkyoClient.SendCommand((command.split ".")[0], (command.split ".")[1])

		setVolume: (volume) ->
			#ToDo implement to support "change volume of <device> to <n>" actions

		changeVolume: (vol) ->
			switch vol
				when "mute"
					@onkyoClient.Mute (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "unmute"
					@onkyoClient.UnMute (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "up"
					@onkyoClient.VolUp (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "down"
					@onkyoClient.VolDown (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				else
					env.logger.info "unknown command: " + vol

		destroy: ->
			clearTimeout @_updateValueTimeout if @_updateValueTimeout?
			super()

	####### ACTION PROVIDER #######
	class SendCommandActionProvider extends env.actions.ActionProvider
		constructor: (@framework) ->

		parseAction: (input, context) =>
			# Get all devices which have a send method
			sendDevices = _(@framework.deviceManager.devices).values().filter(
				(device) => device.hasAction('sendCommand')
			).value()

			device = null
			command = null
			match = null

			# Match action
			# send "<command>" to <device>
			m = M(input, context)
				.match('send ')
				.match('command ', optional: yes)
				.matchStringWithVars((m, _command) ->
					m.match(' to ')
						.matchDevice(sendDevices, (m, _device) ->
							device = _device
							command = _command
							match =	m.getFullMatch()
						)
				)

			# Does the action match with our syntax?
			if match?
				assert device?
				assert command?
				assert typeof match is 'string'
				return {
					token: match
					nextInput: input.substring match.length
					actionHandler: new SendCommandActionHandler @framework, device, command
				}
			return null

	####### ACTION HANDLER ######
	class SendCommandActionHandler extends env.actions.ActionHandler
		constructor: (@framework, @device, @command) ->

		executeAction: (simulate) ->
			return (
				@framework.variableManager.evaluateStringExpression(@command).then((command) =>
					if simulate
						Promise.resolve __('would send command %s to %s', command, @device.name)
					else
						@device.sendCommand command
						Promise.resolve __('sended command %s to %s', command, @device.name)
					)
			)

	return new OnkyoAvrPlugin
