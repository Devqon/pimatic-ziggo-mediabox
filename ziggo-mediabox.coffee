module.exports = (env) ->

  Promise = env.require 'bluebird'
  commons = require('pimatic-plugin-commons')(env)
  ziggoApi = require('./ziggo-api')(env)
  deviceConfigDef = require('./device-config-schema')
  
  class ZiggoMediaboxPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      @_base = commons.base @, 'ZiggoMediaboxPlugin'
      @api = new ziggoApi(@config)

      availableButtons = @api.getAvailableButtons()
      configDef = deviceConfigDef.ZiggoMediaboxRemote
      configDef.properties.buttons.items.properties.id.enum = availableButtons;
      configDef.properties.buttons.default = availableButtons.slice(0, 2).map (button) => { id: button, text: button };

      @framework.deviceManager.registerDeviceClass("ZiggoMediaboxRemote", {
        configDef: configDef,
        createCallback: (config) => 
          return new ZiggoMediaboxRemote(config, @api)
      })

  class ZiggoMediaboxRemote extends env.devices.ButtonsDevice
    constructor: (@config, @api) ->
      @_base = commons.base @, 'ZiggoMediaboxRemote'

      @name = @config.name
      @id = @config.id

      for b in @config.buttons
        b.text = b.id unless b.text?

      super(@config)

    buttonPressed: (buttonId) ->
      @_base.info "Button pressed #{buttonId}"
      for b in @config.buttons
        if b.id is buttonId
          @_lastPressedButton = b.id
          @emit 'button', b.id
          return @api.pressButton(b.id)

      throw new Error("No button with the id #{buttonId} found")

    destroy: () ->
      @api.disconnect().then =>
        @_base.debug "Disconnected ziggo api from remote device destroy"
      super()

    
  ziggoMediaboxPlugin = new ZiggoMediaboxPlugin

  return ziggoMediaboxPlugin