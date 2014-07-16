define [
  "lib/options"
  "lib/svg"
  "views/labels"
  "views/paths"
  "views/positions"
], (Options, Svg, LabelsView, PathsView, PositionsView) ->
  class RaceView
    constructor: (options) ->
      @racers = options.racers
      @width = options.width
      @height = options.height
      @start = options.start
      @end = options.end
      @dx = options.dx

    build: ->
      _.tap(@_race(), (element) =>
        element.appendChild(@_labels().build())
        element.appendChild(@_paths().build())
        element.appendChild(@_positions().build())
      )

    _race: -> Svg.element("g", id: "race" )

    _labels: ->
      new LabelsView(
        width: Options.racer_label_width, height: @height, x: @width
        racers: @racers
      )

    _paths: ->
      new PathsView(
        width: @width, height: @height, dx: @dx
        racers: @racers
        start: @start, end: @end
      )

    _positions: ->
      new PositionsView(
        width: @width, height: @height, dx: @dx
        racers: @racers
        start: @start, end: @end
      )
