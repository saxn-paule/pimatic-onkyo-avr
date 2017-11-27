# onkyo plugin configuration options
module.exports = {
	title: "onkyo"
	OnkyoDevice :{
		title: "Plugin Properties"
		type: "object"
		extensions: ["xLink"]
		properties:
			ip:
				description: "The AVRs IP address"
				type: "string"
				default: "192.168.0.15"
	}
	OnkyoSensor: {
		title: "OnkyoSensor config options",
		type: "object",
		extensions: ["xAttributeOptions"],
		properties: {
			attributes:
				description: "Attributes of device"
				required: ["name"]
				type: "array"
				default: []
				format: "table"
				items:
					type: "object"
					properties:
						display:
							description: "AVR display"
							type: "string"
						volume:
							description: "AVR volume"
							type: "number"
							unit: "dB"
						mute:
							description: "AVR mute status"
							type: "boolean"
						source:
							description: "AVR source"
							type: "string"
						sound:
							description: "AVR sound status"
							type: "string"
			interval:
				description: "the time in ms, the command gets executed to get a new sensor value"
				type: "integer"
				default: 2000
		}
	}
}
