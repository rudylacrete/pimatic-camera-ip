
module.exports = (env) ->

  # ###require modules included in pimatic
  # To require modules that are included in pimatic use `env.require`. For available packages take
  # a look at the dependencies section in pimatics package.json

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  request = require 'request'
  fs = require 'fs'
  path = require 'path'

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
      streamUrl:
        description: 'mjpeg stream url'
        type: 'string'
      pictureUrl:
        description: 'picture url'
        type: 'string'

    actions:
      takePicture:
        description: 'take a picture'

    constructor: (@config) ->
      @name = @config.name
      @id = @config.id
      super()

    # we expose this as an attribute but we can also retrieve the config
    # object client side
    getStreamUrl: ->
      return Promise.resolve(@config.url.stream)

    getPictureUrl: ->
      return Promise.resolve(@config.url.picture)

    test: ->
      console.log 'You can trigger this action with a GET request on'
      console.log 'http://localhost/api/device/{id}/test/'
      console.log '++++++++++++++++ test OK'

    takePicture: ->
      f = (+new Date) + '.jpg'
      p = path.resolve __dirname, @config.outputDir, f
      opts = {}
      if @config.auth.enable == true
        opts =
          auth:
            user: @config.auth.user
            pass: @config.auth.pass
      request(@config.url.picture, opts).pipe(fs.createWriteStream(p))
      .on 'finish', ->
        env.logger.info "Picture saved successfuly into #{p}"
      .on 'error', (err) ->
        env.logger.error "An error occured", err

    template: "cameraip"

  myPlugin = new MyPlugin
  return myPlugin