module.exports = (env) ->

  Promise = env.require 'bluebird'
  box = require('ziggo-mediabox')
  boxButtons = require('ziggo-mediabox/buttons.json')
  commons = require('pimatic-plugin-commons')(env)

  class ZiggoApi
    constructor: (@config) ->
      @_base = commons.base @, "ZiggoApi"

    _connect: () =>
      return new Promise (resolve, reject) =>
        if @box && @box.isConnected()
          resolve()
        else
          if !@box
            @box = new box @config.ip
          @box.connect().then =>
            resolve()
          .catch (errorResult) =>
            reject(errorResult.error)

    pressButton: (button) =>
      return new Promise (resolve, reject) =>
        @_connect().then =>
          @box.press_button button
          resolve()
        .catch (error) =>
          reject(error)

    getAvailableButtons: () =>
      return boxButtons.map (button) => button.name
