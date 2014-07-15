define ["lib/options", "lib/svg", "lib/utils"], (Options, Svg, Utils) ->
  class PathsView
    constructor: (options) ->
      @width = options.width
      @height = options.height
      @dx = options.dx
      @racers = options.racers
      @start = options.start
      @end = options.end

    build: ->
      paths = @_paths()
      _.each(@racers, (racer) => paths.appendChild(@_path(racer)))
      paths

    _paths: ->
      attributes = { id: "paths", width: @width, height: @height }
      Svg.element("svg", attributes)

    _start_path: (position) ->
      start = @_position_to_coord(0, position)
      "M#{start.x},#{start.y}"

    _end_path: (position, index) ->
      end = @_position_to_coord(index, position)
      offset = if @_has_finished(index) then 2 else 1
      end_x = end.x + (offset * Options.racer_path_x_padding)
      "L#{end_x},#{end.y}"

    _position_change: (a, b, index) ->
      point_a = @_position_to_coord(index, a)
      point_b = @_position_to_coord(index + 1, b)

      Utils.curve(point_a, point_b, index + 1)

    _path: (racer) ->
      positions = racer.positions[@start..@end]
      path = @_start_path(positions[0])

      Utils.each_cons(positions, 2, ([a, b], index) =>
        path += @_position_change(a, b, index) if a != b
      )

      last_index = positions.length - 1
      path += @_end_path(positions[last_index], last_index)

      unless @_has_finished(last_index)
        dnf_path = @_dnf(positions[last_index], last_index)

      attributes =
        class: "path racer_#{racer.id}"
        "data-racer": "racer_#{racer.id}"
      style = { stroke: Utils.stroke_colour(racer) }
      _.tap(Svg.element("g", attributes, style), (element) ->
        element.appendChild(Svg.element("path", d: path))
        element.appendChild(dnf_path) if dnf_path?
      )

    _has_finished: (index) -> index == (@end - @start)

    _dnf: (position, index) ->
      end = @_position_to_coord(index, position)
      a = ((@end - @start) * @dx) + (2 * Options.racer_path_x_padding)
      end_x = end.x + (1 * Options.racer_path_x_padding)

      attributes = { d: "M#{end_x},#{end.y}L#{a},#{end.y}", class: "dnf" }

      Svg.element("path", attributes)

    _position_to_coord: (index, position) ->
      Utils.position_to_coord(index, position, @dx)
