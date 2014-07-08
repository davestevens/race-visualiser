define ["lib/options", "lib/svg", "lib/path"], (Options, Svg, Path) ->
  class PathsView
    constructor: (options) ->
      @options = options
      @racers = @_initialize_data()

    render: ->
      attributes = { id: "paths" }
      styles = { strokeWidth: "3px", fill: "none" }
      path_builder = new Path(dx: @options.dx, split_count: @_count())

      _.tap(Svg.element("g", attributes, styles), (element) =>
        _.each(@racers, (racer) =>
          element.appendChild(path_builder.build(racer))
        )
      )

    _initialize_data: ->
      _.map(@options.data, (datum) =>
        positions: datum.positions[@options.start..@options.end]
      )

    _count: -> @options.end - @options.start
