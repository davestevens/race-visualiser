define ["underscore", "lib/options", "lib/svg"], (_, Options, Svg) ->
  class Markers
    constructor: (options) ->
      @options = options

    build: (ticks) ->
      attributes = { id: "markers" }
      styles = { stroke: "#8D8D8D", strokeWidth: "1px", opacity: 0.5 }

      markers_group = Svg.element("g", attributes, styles)
      _.tap(markers_group, (element) =>
        element.appendChild(@_marker(marker)) for marker in [0..@options.splits]
      )

    _marker: (index) ->
      x = (@options.dx * index) + Options.horizontal_padding
      attributes = { x1: x, y1: 0, x2: x, y2: @options.height }
      styles = { strokeWidth: "2px" } unless (index % Options.big_tick)

      Svg.element("line", attributes, styles)
