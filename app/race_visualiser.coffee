define [
  "lib/options"
  "lib/svg"
  "lib/style"
  "views/lap_markers"
  "views/race"
], (Options, Svg, Style, LapMarkersView, RaceView) ->
  class RaceVisualiser
    constructor: (params) ->
      _.extend(Options, params.options)
      @data = params.data
      @el = params.el

      throw new Error "Please define data" unless @data

      @_generate_ids()

    render: (options = {}) ->
      start = options.start || 0
      end = options.end || (@data.splits * @data.laps)

      @splits = end - start

      # TODO: check that it is a valid range...
      @_sort_racers(end)
      @el.appendChild(@build(start, end))

     build: (start, end) ->
      svg = Svg.element("svg", width: @_calculate_width(), height: @_height())
      _.tap(svg, (element) =>
        element.appendChild(@_style().build())

        element.appendChild(@_lap_markers().build())
        element.appendChild(@_race(start, end).build())
      )

    _generate_ids: ->
      _.each(@data.racers, (racer, index) -> racer.id = index)

    _sort_racers: (index) ->
      @data.racers = _.sortBy(@data.racers, (racer) -> racer.positions[index])

    _style: -> new Style()

    _lap_markers: ->
      new LapMarkersView(splits: @splits, height: @_height(), dx: @_dx())

    _race: (start, end) ->
      new RaceView(
        width: @_width(), height: @_height(), dx: @_dx()
        racers: @data.racers, start: start, end: end
      )

    _width: ->
      (Options.width || @_calculate_width()) - Options.racer_label_width

    _height: -> (@data.racers.length + 1) * Options.racer_path_height

    _dx: -> (@_width() - (2 * Options.racer_path_x_padding)) / @splits

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)
