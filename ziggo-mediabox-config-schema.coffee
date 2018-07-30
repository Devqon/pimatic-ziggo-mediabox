# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "Ziggo Mediabox config options"
  type: "object"
  properties:
    ip:
      description: "IP address"
      type: "string"
      default: "192.168."
}