define ["lib/options", "lib/svg"], (Options, Svg) ->
  class Utils
    each_cons: (a, cons_size, fn) ->
      fn(a[i..(i + (cons_size - 1))], i) for i in [0..(a.length - cons_size)]

    stroke_colour: (racer) -> racer.colour || Options.racer_path_default_colour

    position_to_coord: (index, position, dx) ->
      { x: index * dx, y: position * Options.racer_path_height }

    curve: (a, b, index) ->
      Svg.line_to_curve(a, b, { x: Options.racer_path_x_padding })

    add_active_class: (elements) ->
      _.each(elements, (element) => @add_class($(element), "active"))

    remove_active_class: (elements) ->
      _.each(elements, (element) => @remove_class($(element), "active"))

    add_class: ($element, class_name) ->
      current = ($element.attr("class") || "").split(/\s+/)
      updated = _.uniq(current.concat(class_name))
      $element.attr("class", updated.join(" "))

    remove_class: ($element, class_name) ->
      current = ($element.attr("class") || "").split(/\s+/)
      updated = _.reject(current, (name) -> name == class_name)
      $element.attr("class", updated.join(" "))

  new Utils()
