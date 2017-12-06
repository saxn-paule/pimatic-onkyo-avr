# onkyo plugin configuration options
module.exports = {
	title: "onkyo"
	OnkyoAvrDevice :{
		title: "Plugin Properties"
		type: "object"
		extensions: ["xLink", "xAttributeOptions"]
		properties:
			ip:
				description: "The AVRs IP address"
				type: "string"
				default: "192.168.0.15"
			interval:
				description: "poll rate in ms for retrieving AVR status information"
				type: "integer"
				default: 2000
	}
}
