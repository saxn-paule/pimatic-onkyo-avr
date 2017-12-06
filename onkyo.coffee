module.exports = (env) ->

	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
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

			@framework.ruleManager.addActionProvider(new OnkyoActionProvider(@framework))

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

		constructor: (@config, @plugin, lastState) ->
			env.logger.info @config
			@id = @config.id
			@name = @config.name
			@ip = @config.ip or "192.168.0.15"
			@interval = @config.interval || 2000
			@volume = -100
			@display = ""
			@mute = ""
			@source = ""
			@sound = ""
			@power = "off"
			@onkyoClient = null
			@connected = false

			@volume = lastState?["volume"]?.value
			@display = lastState?["display"]?.value
			@mute = lastState?["mute"]?.value
			@source = lastState?["source"]?.value
			@sound = lastState?["sound"]?.value


			@onkyoClient = Onkyo.init(
				log: true
				ip: @ip)

			@onkyoClient.Connect =>
				return

			@onkyoClient.on 'error', (err) ->
				if err
					if err.code is "ETIMEDOUT"
						env.logger.warn "Cannot connect to " + err.address + ":" + err.port
					else
						env.logger.error err

				return

			@onkyoClient.on 'detected', (device) ->
				env.logger.info "device: " + device
				return

			@onkyoClient.on 'connected', (host) ->
				env.logger.info 'connected to: ' + JSON.stringify(host)
				@connected = true

			@onkyoClient.on 'msg', (msg) =>
				@parseMessage(msg)
				return

			updateValue = =>
				if @interval > 0
					@_updateValueTimeout = null
					@_getUpdatedVolume().finally( =>
						@_getUpdatedDisplay().finally( =>
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
			@emit "volume", @volume
			return Promise.resolve @volume

		_getUpdatedDisplay: () =>
			@emit "display", @display
			return Promise.resolve @display

		_getUpdatedMute: () =>
			if not @mute? or @mute is ""
				@onkyoClient.SendCommand("AUDIO", "MuteQstn")
			else
				@emit "mute", @mute

			return Promise.resolve @mute

		_getUpdatedSource: () =>
			if not @source? or @source is ""
				@onkyoClient.SendCommand("SOURCE_SELECT", "QSTN")
			else
				@emit "source", @source

			return Promise.resolve @source

		_getUpdatedSound: () =>
			if not @sound? or @sound is ""
				@onkyoClient.SendCommand("SOUND_MODES", "QSTN")
			else
				@emit "sound", @sound

			return Promise.resolve @sound

		parseMessage: (msg) ->
			env.logger.info msg
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

		destroy: ->
			clearTimeout @_updateValueTimeout if @_updateValueTimeout?
			super()


	####### ACTION HANDLER ######
	class OnkyoActionHandler extends env.actions.ActionHandler
		constructor: (@framework, @commandTokens) ->

		connect: ->
			if not connected
				onkyoClient.Connect ->
					return

		disconnect: ->
			if connected
				onkyoClient.Close ->
					connected = false
					return

		powerOn: ->
			onkyoClient.PwrOn (error, ok) ->
				if error
					env.logger.error error
				if ok
					env.logger.info ok
				return

		powerOff: ->
			onkyoClient.PwrOff (error, ok) ->
				if error
					env.logger.error error
				if ok
					env.logger.info ok
				return

		powerStatus: ->
			if not connected
				onkyoClient.Connect ->
					onkyoClient.PwrState (obj) ->
						env.logger.info obj
			else
				onkyoClient.PwrState (obj) ->
					env.logger.info obj

		setSource: (src) ->
			onkyoClient.SetSource(src, cb) ->
				env.logger.info cb
				return

		sendCommand: (cmd) ->
			onkyoClient.SendCommand((cmd.split ".")[0], (cmd.split ".")[1])

		changeVolume: (vol) ->
			switch vol
				when "mute"
					onkyoClient.Mute (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "unmute"
					onkyoClient.UnMute (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "up"
					onkyoClient.VolUp (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				when "down"
					onkyoClient.VolDown (error, ok) ->
						if error
							env.logger.error error
						if ok
							env.logger.info ok
						return
				else
					env.logger.info "unknown command: " + vol

		executeAction: (simulate) ->
			@framework.variableManager.evaluateStringExpression(@commandTokens).then( (command) =>
				if simulate
					return Promise.resolve("Das ist nur eine Übung: " + command)
				else
					if not connected
						@connect()

					if command.startsWith('SOURCE.') and command.indexOf(".") > 0
						source = (command.split ".")[1]
						@setSource(source)
					else
						switch command
							when 'Power.ON'
								@powerOn()
							when 'Power.OFF'
								@powerOff()
							when 'Power.STATUS'
								@powerStatus()
							when 'Volume.MUTE'
								@changeVolume("mute")
							when 'Volume.UNMUTE'
								@changeVolume("unmute")
							when 'Volume.UP'
								@changeVolume("up")
							when 'Volume DOWN'
								@changeVolume("down")
							else
								@sendCommand(command)

					return Promise.resolve("done")
			)

	####### ACTION PROVIDER #######
	class OnkyoActionProvider extends env.actions.ActionProvider
		constructor: (@framework, @plugin)->
			env.logger.info "OnkyoActionProvider meldet sich zum Dienst"
			return

		executeAction: (simulate) =>
			env.logger.info "OnkyoActionProvider meldet gehorsamst: Ausführung!"
			return

		parseAction: (input, context) =>
			commandTokens = null
			fullMatch = no

			setCommand = (m, tokens) => commandTokens = tokens
			onEnd = => fullMatch = yes

			m = M(input, context)
				.match("sendOnkyo ")
				.matchStringWithVars(setCommand)

			if m.hadMatch()
				match = m.getFullMatch()
				return {
					token: match
					nextInput: input.substring(match.length)
					actionHandler: new OnkyoActionHandler(@framework, commandTokens)
				}
			else
				return null

	onkyoAvrPlugin = new OnkyoAvrPlugin
	return onkyoAvrPlugin