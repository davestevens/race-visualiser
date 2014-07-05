define ["backbone"], (Backbone) ->
  RaceVisualiser = Backbone.View.extend
    initialize: (options) ->
      @data = options.data

    render: (options = {}) ->
      start = options.start || 0
      end = options.end || (@data.splits * @data.laps)

      # Get width and height
      console.log @_width(), @_height()
      # Create an svg (container)

      console.log start, end
      # render paths (based on start + end)
      # render labels (based on end)

    # Options
    path_height: 20

    _width: -> @width || @_calculate_width()
    _height: -> @height || @_calculate_height()

    _calculate_width: -> @el.offsetWidth
    _calculate_height: -> @data.data.length * @path_height
