define [
  "backbone"
  "views/labels"
], (Backbone, LabelsView) ->
  RaceVisualiser = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)
      @data = @options.data

      throw new Error "Please define data" unless @data

    render: (options = {}) ->
      start = @options.start || 0
      end = @options.end || (@data.splits * @data.laps) - 1

      # Get width and height
      console.log @_width(), @_height()
      # Create an svg (container)

      console.log start, end
      # render paths (based on start + end)

      # render labels (based on end)
      $labels = $("<div/>", id: "labels", width: @options.labels_width)
        .appendTo(@$el)
      @labels_view = new LabelsView(el: $labels, collection: @data.data)
      @labels_view.render(end)

    # Options
    options:
      path_height: 20
      labels_width: 150

    _width: -> (@width || @_calculate_width()) - @options.labels_width
    _height: -> @height || @_calculate_height()

    _calculate_width: -> @el.offsetWidth
    _calculate_height: -> @data.data.length * @options.path_height
