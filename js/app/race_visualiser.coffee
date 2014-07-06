define [
  "backbone"
  "views/paths"
  "views/labels"
], (Backbone, PathsView, LabelsView) ->
  RaceVisualiser = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)
      @data = @options.data

      throw new Error "Please define data" unless @data

      _.each(@data.data, (datum, index) -> datum.id = "d#{index}")

    render: (options = {}) ->
      start = @options.start || 0
      end = @options.end || (@data.splits * @data.laps)

      # render paths (based on start + end)
      $paths = $("<div/>", id: "paths", width: @_width())
        .appendTo(@$el)
      @paths_view = new PathsView
        el: $paths
        collection: @data.data
        width: @_width()
        horizontal_padding: @options.horizontal_padding
        path_height: @options.path_height
      @paths_view.render(start, end)

      # render labels (based on end)
      $labels = $("<div/>", id: "labels", width: @options.labels_width)
        .appendTo(@$el)
      @labels_view = new LabelsView
        el: $labels
        collection: @data.data
        path_height: @options.path_height
      @labels_view.render(end)

    # Options
    options:
      horizontal_padding: 30
      path_height: 20
      labels_width: 150

    _width: -> (@width || @_calculate_width()) - @options.labels_width

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)
