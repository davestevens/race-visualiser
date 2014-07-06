define [
  "backbone"
  "lib/svg"
  "lib/style"
  "lib/markers"
  "lib/paths"
  "lib/position_markers"
], (Backbone, Svg, Style, Markers, Paths, PositionMarkers) ->
  PathsView = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @options.height)

      _.tap(svg, (element) =>
        element.appendChild(@_style().build())
        element.appendChild(@_markers().build())
        element.appendChild(@_paths().build(start, end))
        element.appendChild(@_position_markers().build(start, end))
      )

    options:
      horizontal_padding: 30
      path_height: 20

    _style: -> new Style()

    _markers: ->
      new Markers
        splits: @splits
        height: @options.height
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding

    _paths: ->
      new Paths
        data: @collection
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding
        path_height: @options.path_height

    _position_markers: ->
      new PositionMarkers
        data: @collection
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding
        path_height: @options.path_height

    _width: -> @options.width - (2 * @options.horizontal_padding)

    _dx: -> @_width() / @splits
