define ["lib/options", "lib/svg"], (Options, Svg) ->
  class Utils
    each_cons: (a, cons_size, fn) ->
      fn(a[i..(i + (cons_size - 1))], i) for i in [0..(a.length - cons_size)]

    stroke_colour: (racer) -> racer.colour || Options.racer_path_default_colour

    position_to_coord: (index, position, dx) ->
      { x: index * dx, y: position * Options.racer_path_height }

    curve: (a, b, index) ->
      Svg.line_to_curve(a, b, { x: Options.racer_path_x_padding })

  new Utils()
