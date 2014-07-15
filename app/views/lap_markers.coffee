define ["underscore", "lib/options", "lib/svg"], (_, Options, Svg) ->
  class LapMarkersView
    constructor: (options) ->
      @options = options

    build: (ticks) ->
      _.tap(@_lap_markers, (element) =>
        element.appendChild(@_marker(marker)) for marker in [0..@options.splits]
      )

    _lap_markers: Svg.element("g", id: "lap_markers")

    _marker: (index) ->
      x = (@options.dx * index) + Options.racer_path_x_padding
      attributes = { class: "marker", x1: x, y1: 0, x2: x, y2: @options.height }
      attributes.class += " big" unless (index % Options.lap_marker_big_tick)

      Svg.element("line", attributes)
