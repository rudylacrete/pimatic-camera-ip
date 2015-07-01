# #Plugin template

# This is an plugin template and mini tutorial for creating pimatic plugins. It will explain the
# basics of how the plugin system works and how a plugin should look like.

# ##The plugin code

# Your plugin must export a single function, that takes one argument and returns a instance of
# your plugin class. The parameter is an envirement object containing all pimatic related functions
# and classes. See the [startup.coffee](http://sweetpi.de/pimatic/docs/startup.html) for details.
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # Include you own depencies with nodes global require function:
  #
  #     someThing = require 'someThing'
  #

  # ###MyPlugin class
  # Create a class that extends the Plugin class and implements the following functions:
  class MyPlugin extends env.plugins.Plugin

    # ####init()
    # The `init` function is called by the framework to ask your plugin to initialise.
    #
    # #####params:
    #  * `app` is the [express] instance the framework is using.
    #  * `framework` the framework itself
    #  * `config` the properties the user specified as config for your plugin in the `plugins`
    #     section of the config.json file
    #
    #
    init: (app, @framework, @config) ->
      deviceConfigDef = require('./device-config-schema')

      @framework.deviceManager.registerDeviceClass 'CameraIp',{
        configDef: deviceConfigDef.CameraIp
        createCallback: (config) -> new CameraIp(config)
      }

      @framework.on 'after init', =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        mobileFrontend.registerAssetFile 'js', "pimatic-camera-ip/app/camera.coffee"
        mobileFrontend.registerAssetFile 'css', "pimatic-camera-ip/app/camera.css"
        mobileFrontend.registerAssetFile 'html', "pimatic-camera-ip/app/camera.jade"

      env.logger.info("Init OK ...")




  class CameraIp extends env.devices.Device

    attributes:
      url:
        description: 'video url'
        type: "string"

    constructor: (@config) ->
      @name = @config.name
      @id = @config.id
      @url = config.url
      console.log '///////////////', @url
      super()

    getUrl: ->
      return Promise.resolve(@url)

    template: "cameraip"

  myPlugin = new MyPlugin
  return myPlugin