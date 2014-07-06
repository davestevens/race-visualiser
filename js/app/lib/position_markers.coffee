define ["underscore", "lib/svg"], (_, Svg) ->
  class PositionMarkers
    constructor: (options) -> _.extend(@options, options)

    options: {}

    build: (start, end) ->
      attributes = { id: "position_markers" }

      positions_selection = _.map(@options.data, (datum) ->
        positions: datum.positions[start..end]
        count: end - start
        id: datum.id
      )

      position_markers_group = Svg.element("g", attributes)
      _.tap(position_markers_group, (element) =>
        element.appendChild(@_markers(item)) for item in positions_selection
      )

    _markers: (options) ->
      positions = options.positions
      length = positions.length

      group = Svg.element("g", { visibility: "hidden" })
      _.tap(group, (element) =>
        for index in [1...length]
          if @_position_change(positions, index)
            point = @_position_to_coord(index, positions[index])
            element.appendChild(@_marker(point))
            element.appendChild(@_marker_text(point, positions[index]))

        attributes =
          attributeName: "visibility"
          from: "hidden"
          to: "visible"
          begin: "#{options.id}.mouseover"
          end: "#{options.id}.mouseout"

        element.appendChild(Svg.element("set", attributes))
      )

    _position_to_coord: (index, position) ->
      { x: index * @options.dx, y: position * @options.path_height }

    _position_change: (positions, index) ->
      positions[index] != positions[index - 1]

    _marker: (point) ->
      attributes =
        cx: point.x + @options.horizontal_padding
        cy: point.y
        r: 10
      styles =
        stroke: "#8D8D8D"
        strokeWidth: "1px"
        fill: "white"

      Svg.element("circle", attributes, styles)

    _marker_text: (point, text) ->
      attributes =
        x: point.x + @options.horizontal_padding
        y: point.y
      styles =
        fontSize: "15px"
        textAnchor: "middle"
        dominantBaseline: "central"

      _.tap(Svg.element("text", attributes, styles), (element) ->
        element.textContent = text
      )
