define ["backbone", "lib/svg"], (Backbone, Svg) ->
  LabelsView = Backbone.View.extend
    initialize: (options) -> _.extend(@options, options)

    options:
      path_height: 20

    render: (index) ->
      attributes =
        width: @options.width
        height: @options.height
        x: @options.x_offset

      svg = Svg.element("svg", attributes)
      _.chain( @collection )
        .sortBy( (item) -> item.positions[index] )
        .each( (item, index) => svg.appendChild(@_render_item(item, index)) )
      svg

    _render_item: (item, index) ->
      attributes = { x: 2,  y: @_y_offset(index) }
      styles = { dominantBaseline: "middle" }

      _.tap(Svg.element("text", attributes, styles), (element) ->
        element.textContent = item.label
      )

    _y_offset: (index) -> @options.path_height + (@options.path_height * index)
