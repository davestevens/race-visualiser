define ["lib/options", "lib/svg"], (Options, Svg) ->
  class LapNumbers
    constructor: (options) ->
      @height = options.height
      @dx = options.dx
      @start = options.start
      @end = options.end

    build: ->
      numbers = @_numbers()
      for index in [@start..@end] by Options.lap_marker_big_tick
        continue if index == 0
        label = index / Options.lap_marker_big_tick
        numbers.appendChild(@_number((index - @start), label))
      numbers

    _numbers: -> Svg.element("g", id: "lap_number")

    _number: (index, label) ->
      x = (@dx * index) + Options.racer_path_x_padding
      attributes =
        class: "number"
        x: x, y: @height + Options.lap_marker_label_height / 2, dy: "0.3em"

      _.tap(Svg.element("text", attributes), (element) ->
        element.textContent = label
      )
