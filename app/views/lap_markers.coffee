define [
  "underscore"
  "lib/options"
  "lib/svg"
  "views/laps/markers"
  "views/laps/numbers"
], (_, Options, Svg, LapMarkers, LapNumbers) ->
  class LapMarkersView
    constructor: (options) ->
      @start = options.start
      @end = options.end
      @height = options.height
      @dx = options.dx

    build: (ticks) ->
      _.tap(@_lap_markers, (element) =>
        element.appendChild(@_markers().build())
        element.appendChild(@_numbers().build())
      )

    _lap_markers: Svg.element("g", id: "lap_markers")

    _markers: ->
      new LapMarkers(
        height: @height, dx: @dx
        splits: @end - @start
      )

    _numbers: ->
      new LapNumbers(
        height: @height, dx: @dx
        start: @start, end: @end
      )
