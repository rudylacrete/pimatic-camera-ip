$(document).on 'templateinit', (event) ->
  
  # define the item class
  class CameraIp extends pimatic.DeviceItem
    constructor: (data, @device) ->
      super(data, @device)
      @streamUrl = @getAttribute('streamUrl').value()
      # Do something, after create: console.log(this)
    afterRender: (elements) -> 
      super(elements)
      # Do something after the html-element was added

    takePicture: ->
      @device.rest.takePicture().fail(ajaxAlertFail)

      
  # register the item-class
  pimatic.templateClasses['cameraip'] = CameraIp
