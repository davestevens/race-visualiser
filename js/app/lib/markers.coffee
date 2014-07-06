define ["underscore", "lib/svg"], (_, Svg) ->
  class Markers
    constructor: (options) -> _.extend(@options, options)

    options: {}

    build: ->
      attributes = { id: "markers" }
      styles = { stroke: "#8D8D8D", strokeWidth: "1px", opacity: 0.6 }

      markers_group = Svg.element("g", attributes, styles)
      _.tap(markers_group, (element) =>
        element.appendChild(@_marker(marker)) for marker in [0..@options.splits]
      )

    _marker: (index) ->
      x = (@options.dx * index) + @options.horizontal_padding
      attributes = { x1: x, y1: 0, x2: x, y2: @options.height }

      Svg.element("line", attributes)