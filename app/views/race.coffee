define [
  "lib/options"
  "lib/svg"
  "lib/style"
  "lib/lap_markers"
  "views/paths"
], (Options, Svg, Style, LapMarkers, PathsView) ->
  class RaceView
    constructor: (options = {}) ->
      @options = options

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @options.height)

      _.tap(svg, (element) =>
        element.appendChild(@_lap_markers().build())
        element.appendChild(@_paths(start, end).render())
      )

    _lap_markers: ->
      new LapMarkers
        splits: @splits
        height: @options.height
        dx: @_dx()

    _paths: (start, end) ->
      new PathsView
        data: @options.collection
        dx: @_dx()
        start: start
        end: end

    _width: -> @options.width - (2 * Options.horizontal_padding)

    _dx: -> @_width() / @splits
