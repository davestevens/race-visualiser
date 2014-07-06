define [
  "backbone"
  "lib/svg"
  "lib/markers"
  "lib/paths"
], (Backbone, Svg, Markers, Paths) ->
  PathsView = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @_height())
      markers = new Markers
        splits: @splits
        height: @_height()
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding
      svg.appendChild(markers.build())

      paths = new Paths
        data: @collection
        dx: @_dx()
        horizontal_padding: @options.horizontal_padding
      svg.appendChild(paths.build())

      @$el.html(svg)

    options:
      horizontal_padding: 30

    _width: -> @options.width - (2 * @options.horizontal_padding)
    _height: -> @collection.length * @options.path_height

    _dx: -> @_width() / @splits
