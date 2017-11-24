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
}
