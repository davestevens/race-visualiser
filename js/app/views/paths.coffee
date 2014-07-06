define [
  "backbone"
  "lib/svg"
  "lib/style"
  "lib/markers"
  "lib/paths"
], (Backbone, Svg, Style, Markers, Paths) ->
  PathsView = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @_height())

      svg.appendChild(@_style().build())
      svg.appendChild(@_markers().build())
      svg.appendChild(@_paths().build(start, end))

      @$el.html(svg)

    options:
      horizontal_padding: 30

    _style: -> new Style()

    _markers: ->
      new Markers
        splits: @splits
        height: @_height()
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding

    _paths: ->
      new Paths
        data: @collection
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding

    _width: -> @options.width - (2 * @options.horizontal_padding)
    _height: -> @collection.length * @options.path_height

    _dx: -> @_width() / @splits
