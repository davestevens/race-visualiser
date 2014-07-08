define [
  "lib/options"
  "lib/svg"
  "lib/style"
  "lib/markers"
  "lib/paths"
], (Options, Svg, Style, Markers, Paths) ->
  class PathsView
    constructor: (options = {}) ->
      @options = options

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @options.height)

      _.tap(svg, (element) =>
        element.appendChild(@_markers().build())
        element.appendChild(@_paths().build(start, end))
      )

    _markers: ->
      new Markers
        splits: @splits
        height: @options.height
        dx: @_dx()

    _paths: ->
      new Paths
        data: @options.collection
        dx: @_dx()

    _width: -> @options.width - (2 * Options.horizontal_padding)

    _dx: -> @_width() / @splits
