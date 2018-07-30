module.exports = (env) ->

  Promise = env.require 'bluebird'
  box = require('ziggo-mediabox')
  commons = require('pimatic-plugin-commons')(env)

  class ZiggoApi
    constructor: (@config) ->

    connect: () =>
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
        @connect().then
          @box.press_button button
          resolve()
        .catch (error) =>
          reject(error)