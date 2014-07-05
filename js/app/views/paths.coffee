define [
  "backbone"
  "lib/svg"
  "lib/markers"
], (Backbone, Svg, Markers) ->
  PathsView = Backbone.View.extend
    initialize: (options = {}) ->
      _.extend(@options, options)

    render: (start, end) ->
      @splits = end - start
      svg = Svg.element("svg", width: @options.width, height: @_height())
      markers = new Markers
        splits: @splits
        width: @options.width
        height: @_height()
      svg.appendChild(markers.build())
      @$el.html(svg)

    options: {}

    _height: -> @collection.length * @options.path_height
