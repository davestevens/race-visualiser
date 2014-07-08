define ["backbone", "lib/options", "lib/svg"], (Backbone, Options, Svg) ->
  LabelsView = Backbone.View.extend
    initialize: (options) ->
      @options = options

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

    _y_offset: (index) -> Options.path_height + (Options.path_height * index)
