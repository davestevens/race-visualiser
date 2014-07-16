define ["lib/options", "lib/svg", "lib/utils"], (Options, Svg, Utils) ->
  class PositionsView
    constructor: (options) ->
      @width = options.width
      @height = options.height
      @dx = options.dx
      @racers = options.racers
      @start = options.start
      @end = options.end

    build: ->
      positions = @_positions()
      _.each(@racers, (racer) => positions.appendChild(@_markers(racer)))
      positions

    _positions: ->
      attributes = { id: "positions", width: @width, height: @height }
      Svg.element("svg", attributes)

    _get_positions: (positions) ->
      _positions = positions[@start..@end]
      return [positions[positions.length - 1]] if _.isEmpty(_positions)
      _positions

    _markers: (racer) ->
      attributes = { class: "position racer_#{racer.id}" }
      styles = { stroke: Utils.stroke_colour(racer) }
      group = Svg.element("g", attributes, styles)

      positions = @_get_positions(racer.positions)

      Utils.each_cons(positions, 2, ([a, b], index) =>
        if a != b && b?
          group.appendChild(@_marker_and_text(index, positions))
      )

      group.appendChild(@_marker_and_text(positions.length - 1, positions))

      group

    _marker_and_text: (index, positions) ->
      position = positions[index]
      point = @_position_to_coord(index, position)

      _.tap(Svg.element("g"), (element) =>
        element.appendChild(@_marker(point, position))
        element.appendChild(@_text(point, position))
      )

    _marker: (point, label) ->
      attributes =
        class: "marker_circle"
        cx: point.x + Options.racer_path_x_padding
        cy: point.y
        r: Options.racer_position_marker_size
      Svg.element("circle", attributes)

    _text: (point, label) ->
      attributes =
        class: "marker_text"
        x: point.x + Options.racer_path_x_padding, y: point.y, dy: "0.3em"

      _.tap(Svg.element("text", attributes), (element) ->
        element.textContent = label
      )

    _position_to_coord: (index, position) ->
      Utils.position_to_coord(index, position, @dx)
