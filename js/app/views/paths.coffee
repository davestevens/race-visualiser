define [
  "backbone"
  "lib/options"
  "lib/svg"
  "lib/style"
  "lib/markers"
  "lib/paths"
], (Backbone, Options, Svg, Style, Markers, Paths) ->
  PathsView = Backbone.View.extend
    initialize: (options = {}) ->
      @options = options

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @options.height)

      _.tap(svg, (element) =>
        element.appendChild(@_markers().build())
        element.appendChild(@_paths().build(start, end))
      )

    _markers: ->
      new Markers
        splits: @splits
        height: @options.height
        dx: @_dx()

    _paths: ->
      new Paths
        data: @collection
        dx: @_dx()

    _width: -> @options.width - (2 * Options.horizontal_padding)

    _dx: -> @_width() / @splits
