define [
  "lib/options"
  "lib/svg"
  "lib/style"
  "views/race"
  "views/racers"
], (Options, Svg, Style, RaceView, RacersView) ->
  class RaceVisualiser
    constructor: (params) ->
      _.extend(Options, params.options)
      @data = params.data
      @el = params.el

      throw new Error "Please define data" unless @data

    render: (options = {}) ->
      start = options.start || 0
      end = options.end || (@data.splits * @data.laps)

      svg = Svg.element("svg", width: @_calculate_width(), height: @_height())
      svg.appendChild(@_style().build())

      svg.appendChild(@_race_view().render(start, end))
      svg.appendChild(@_racers_view().render(end))

      @el.appendChild(svg)

    _race_view: ->
      @paths_view ||= new RaceView
        collection: @data.data
        width: @_width()
        height: @_height()

    _racers_view: ->
      @labels_view ||= new RacersView
        collection: @data.data
        width: Options.labels_width
        height: @_height()
        x_offset: @_width()

    _width: -> (@width || @_calculate_width()) - Options.labels_width
    _height: -> (@data.data.length + 1) * Options.path_height

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)

    _style: -> new Style()
