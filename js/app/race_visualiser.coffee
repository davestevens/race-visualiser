define [
  "backbone"
  "lib/svg"
  "lib/style"
  "views/paths"
  "views/labels"
], (Backbone, Svg, Style, PathsView, LabelsView) ->
  RaceVisualiser = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)
      @data = @options.data

      throw new Error "Please define data" unless @data

    render: (options = {}) ->
      start = @options.start || 0
      end = @options.end || (@data.splits * @data.laps)

      svg = Svg.element("svg", width: @_calculate_width(), height: @_height())
      svg.appendChild(@_style().build())

      paths_view = new PathsView
        collection: @data.data
        width: @_width()
        height: @_height()
        horizontal_padding: @options.horizontal_padding
        path_height: @options.path_height
      svg.appendChild(paths_view.render(start, end))

      labels_view = new LabelsView
        collection: @data.data
        width: @options.labels_width
        height: @_height()
        path_height: @options.path_height
        x_offset: @_width()
      svg.appendChild(labels_view.render(end))

      @$el.html(svg)

    # Options
    options:
      horizontal_padding: 30
      path_height: 20
      labels_width: 150

    _width: -> (@width || @_calculate_width()) - @options.labels_width
    _height: -> (@data.data.length + 1) * @options.path_height

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)

    _style: -> new Style()
