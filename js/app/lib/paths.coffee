define [
  "underscore"
  "lib/svg"
  "lib/position_markers"
], (_, Svg, PositionMarkers) ->
  class Paths
    constructor: (options) -> _.extend(@options, options)

    options: {}

    build: (start, end) ->
      attributes = { id: "paths" }
      styles = { strokeWidth: "3px", fill: "none" }

      positions_selection = _.map(@options.data, (datum) ->
        positions: datum.positions[start..end]
        count: end - start
      )

      _.tap(Svg.element("g", attributes, styles), (element) =>
        element.appendChild(@_path(item)) for item in positions_selection
      )

    _path: (options) ->
      positions = options.positions
      length = positions.length
      markers = new PositionMarkers
        horizontal_padding: @options.horizontal_padding

      start = @_position_to_coord(0, positions[0])
      path = "M#{start.x},#{start.y}"
      markers.build(start, positions[0])

      for index in [1...length]
        if @_position_change(positions, index)
          point_a = @_position_to_coord(index - 1, positions[index - 1])
          point_b = @_position_to_coord(index, positions[index])

          path += @_curve(point_a, point_b, index)
          markers.build(point_b, positions[index])

      end = @_position_to_coord(length - 1, positions[length - 1])
      end_x = options.count * @options.dx
      path += "L#{end_x + (2 * @options.horizontal_padding)},#{end.y}"
      # TODO: display when non-finisher (create a non-finish marker?)
      markers.build(end, positions[length - 1])

      _.tap(Svg.element("g", null, stroke: "#8D8D8D"), (group) ->
        group.appendChild(Svg.element("path", d: path))
        group.appendChild(markers.group)
      )

    _position_to_coord: (index, position) ->
      { x: index * @options.dx, y: position * @options.path_height }

    _position_change: (positions, index) ->
      positions[index] != positions[index - 1]

    _curve: (a, b, index) ->
      Svg.line_to_curve(a, b, { x: @options.horizontal_padding })
