define [
  "backbone"
  "lib/options"
  "lib/svg"
  "lib/style"
  "views/paths"
  "views/labels"
], (Backbone, Options, Svg, Style, PathsView, LabelsView) ->
  RaceVisualiser = Backbone.View.extend
    initialize: (params) ->
      _.extend(Options, params.options)
      @data = params.data

      throw new Error "Please define data" unless @data

    render: (options = {}) ->
      start = options.start || 0
      end = options.end || (@data.splits * @data.laps)

      svg = Svg.element("svg", width: @_calculate_width(), height: @_height())
      svg.appendChild(@_style().build())

      svg.appendChild(@_paths_view().render(start, end))
      svg.appendChild(@_labels_view().render(end))

      @$el.html(svg)

    _paths_view: ->
      @paths_view ||= new PathsView
        collection: @data.data
        width: @_width()
        height: @_height()

    _labels_view: ->
      @labels_view ||= new LabelsView
        collection: @data.data
        width: Options.labels_width
        height: @_height()
        x_offset: @_width()

    _width: -> (@width || @_calculate_width()) - Options.labels_width
    _height: -> (@data.data.length + 1) * Options.path_height

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)

    _style: -> new Style()
