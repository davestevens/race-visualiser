define ["lib/options", "lib/svg"], (Options, Svg) ->
  class LapMarkers
    constructor: (options) ->
      @height = options.height
      @dx = options.dx
      @splits = options.splits

    build: ->
      markers = @_markers
      _.each([0..@splits], (index) => markers.appendChild(@_marker(index)))
      markers

    _markers: Svg.element("g", id: "markers")

    _marker: (index) ->
      x = (@dx * index) + Options.racer_path_x_padding
      attributes = { class: "marker", x1: x, y1: 0, x2: x, y2: @height }
      attributes.class += " big" unless (index % Options.lap_marker_big_tick)

      Svg.element("line", attributes)
