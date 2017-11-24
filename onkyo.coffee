module.exports = (env) ->

	Promise = env.require 'bluebird'
	assert = env.require 'cassert'
	M = env.matcher
	t = env.require('decl-api').types
	Onkyo = require 'onkyo.js'
	onkyoClient = null
	connected = false
	power = null
	currentVolume = -100
	currentDisplay = "Test"

	class OnkyoPlugin extends env.plugins.Plugin
		init: (app, @framework, @config) =>

			@framework.ruleManager.addActionProvider(new OnkyoActionProvider(@framework))

			deviceConfigDef = require("./device-config-schema")

			@framework.deviceManager.registerDeviceClass("OnkyoSensor", {
				configDef: deviceConfigDef.OnkyoSensor,
				createCallback: (config, lastState) -> new OnkyoSensor(config, lastState)
			})

			@framework.deviceManager.registerDeviceClass("OnkyoDevice",{
				configDef : deviceConfigDef.OnkyoDevice,
				createCallback : (config) => new OnkyoDevice(config,this)
			})

	class OnkyoDevice extends env.devices.Device
		attributes:
			ip:
				description: 'the AVRs IP address'
				type: t.string

		constructor: (@config, @plugin) ->
			@id = @config.id
			@name = @config.name
			@ip = @config.ip or "192.168.0.15"

			onkyoClient = Onkyo.init(
				log: true
				ip: @ip)

			onkyoClient.Connect ->

			onkyoClient.on 'error', (err) ->
				env.logger.error err
				return

			onkyoClient.on 'detected', (device) ->
				env.logger.info "device: " + device
				return

			onkyoClient.on 'connected', (host) ->
				env.logger.info 'connected to: ' + JSON.stringify(host)
				connected = true

			onkyoClient.on 'msg', (msg) =>
				@parseMessage(msg)
				return

			super()

		getIp: -> Promise.resolve(@ip)

		setIp: (value) ->
			if @ip is value then return
			@ip = value

		parseMessage: (msg) ->
			env.logger.info "Parsing message..."
			env.logger.info msg
			if typeof msg isnt 'object'
				message = JSON.parse(msg)
			else
				message = msg

			if message.hasOwnProperty 'PWR'
				power = message["PWR"]

			if message.hasOwnProperty 'MVL'
				currentVolume = message["MVL"]/2 - 82


		destroy: ->
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
			onkyoClient.PwrState (obj) ->
				env.logger.info obj

		executeAction: (simulate) ->
			@framework.variableManager.evaluateStringExpression(@commandTokens).then( (command) =>
				if simulate
					return Promise.resolve("Das ist nur eine Übung: " + command)
				else
					if not connected
						@connect()

					switch command
						when 'Power ON'
							@powerOn()
						when 'Power OFF'
							@powerOff()
						when 'Power STATUS'
							@powerStatus()
						else
							env.logger.info "unknown command" + command

					env.logger.info "Sending...."
					env.logger.info command
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


	class OnkyoSensor extends env.devices.Sensor
		attributes:
			volume:
				description: 'the AVRs volume'
				type: t.number
			display:
				description: 'the AVRs display'
				type: t.string

		constructor: (@config, lastState) ->
			env.logger.info @config
			@name = @config.name
			@id = @config.id

			@volValue = lastState?["volume"]?.value

			@getVolume = () =>
				if @volValue? then Promise.resolve(@volValue)
				else @_getUpdatedAttributeValue()

			updateValue = =>
				if @config.interval > 0
					@_updateValueTimeout = null
					@_getUpdatedAttributeValue().finally( =>
						@_updateValueTimeout = setTimeout(updateValue, @config.interval)
					)

			super()
			updateValue()

		destroy: () ->
			clearTimeout @_updateValueTimeout if @_updateValueTimeout?
			super()

		_getUpdatedAttributeValue: () ->
				return @volValue

	onkyoPlugin = new OnkyoPlugin
	return onkyoPlugin