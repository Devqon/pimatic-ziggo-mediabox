module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')
  ziggoApi = require('./ziggo-api')
  
  class ZiggoMediaboxPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      @_base = commons.base @, 'ZiggoMediaboxPlugin'

      @framework.deviceManager.registerClass("ZiggoMediaboxRemote", {
        configDev: deviceConfigDev.ZiggoMediabox,
        createCallback: (config) => new ZiggoMediaboxRemote(@config)
      })

  class ZiggoMediaboxRemote extends env.devices.ButtonsDevice
    constructor: (@config) ->
      @id = @config.id
      @name = @config.name
      @api = new ziggoApi(config)
      super(@config)

    buttonPressed: (buttonId) =>
      for b in @config.buttons
        if b.id is buttonId
          @_lastPressedButton = b.id
          emit 'button', b.id
          return @api.pressButton(b.id)
    
  # ###Finally
  # Create a instance of my plugin
  ziggoMediaboxPlugin = new ZiggoMediaboxPlugin
  # and return it to the framework.
  return ziggoMediaboxPlugin