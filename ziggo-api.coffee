module.exports = (env) ->

  Promise = env.require 'bluebird'
  box = require('ziggo-mediabox')
  boxButtons = require('ziggo-mediabox/buttons.json')
  commons = require('pimatic-plugin-commons')(env)

  class ZiggoApi
    constructor: (@config) ->
      @_base = commons.base @, "ZiggoApi"

    _connect: () =>
      if @box && @box.isConnected()
        return new Promise (resolve, reject) =>
          resolve()
      else
        if !@box
          @box = new box @config.ip
        return @box.connect()

    disconnect: () =>
      if @box && @box.isConnected()
        return @xbox.disconnect()
      return new Promise (resolve, reject) =>
        resolve()

    sendRequest: (command) =>
      return new Promise (resolve, reject) =>
        @_connect().then =>
          @box.pressButton command
          resolve()
        .catch (error) =>
          reject(error)

    getAvailableButtons: () =>
      return boxButtons.map (button) => button.name
