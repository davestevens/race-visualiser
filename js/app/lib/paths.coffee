define ["underscore", "lib/svg"], (_, Svg) ->
  class Paths
    constructor: (options) -> _.extend(@options, options)

    options: {}

    build: ->
      attributes = { id: "paths" }
      styles = { strokeWidth: "3px", fill: "none" }

      paths_group = Svg.element("g", attributes, styles)
      _.tap(paths_group, (element) =>
        element.appendChild(@_path(a.positions)) for a in @options.data
      )

    _path: (positions) ->
      length = positions.length

      start = @_position_to_coord(0, positions[0])
      path = "M#{start.x},#{start.y}"

      for index in [1...length]
        path += @_curve(positions, index) if @_position_change(positions, index)

      end = @_position_to_coord(length - 1, positions[length - 1])
      path += "L#{end.x + (2 * @options.horizontal_padding)},#{end.y}"

      attributes = { d: path }
      styles = { stroke: "#8D8D8D" }
      Svg.element("path", attributes, styles)

    _position_to_coord: (index, position) ->
      # TODO: Make dy (20) an option
      { x: index * @options.dx, y: position * 20 }

    _position_change: (positions, index) ->
      positions[index] != positions[index - 1]

    _curve: (positions, index) ->
      a1 = @_position_to_coord(index - 1, positions[index - 1])
      a2 = @_position_to_coord(index, positions[index])

      Svg.line_to_curve(a1, a2, { x: @options.horizontal_padding })
