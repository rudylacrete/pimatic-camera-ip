$(document).on 'templateinit', (event) ->
  
  # define the item class
  class CameraIp extends pimatic.DeviceItem
    constructor: (data, @device) ->
      super(data, @device)
      @url = @getAttribute('url').value()
      # Do something, after create: console.log(this)
    afterRender: (elements) -> 
      super(elements)
      # Do something after the html-element was added

    onShowPress: ->
      console.log '............... ok'
      
  # register the item-class
  pimatic.templateClasses['cameraip'] = CameraIp
