module.exports =
  title: 'pimatic-camera-ip device config schemas'
  CameraIp:
    title: 'Camera IP config options'
    type: 'object'
    properties:
      url:
        type: 'object'
        properties:
          stream:
            description: 'MJPEG stream url'
            type: 'string'
          picture:
            description: 'image capture url'
            type: 'string'
      outputDir:
        description: 'path where to store pictures'
        type: 'string'
        default: './out'
      auth:
        description: 'authentication information'
        type: 'object'
        properties:
          enable:
            type: 'boolean'
            default: false
          user:
            type: 'string'
            default: ''
          pass:
            type: 'string'
            default: ''