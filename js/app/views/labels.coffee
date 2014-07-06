define ["backbone"], (Backbone) ->
  LabelsView = Backbone.View.extend
    initialize: (options) -> _.extend(@options, options)

    options:
      path_height: 20

    render: (index) ->
      $ordered_list = $("<ol/>"
        style: "padding-top:#{@options.path_height / 2}px"
      )

      _.chain( @collection )
        .sortBy( (item) -> item.positions[index] )
        .each( (item) => $ordered_list.append(@_render_item(item)) )

      @$el.html($ordered_list)

    _render_item: (item) ->
      $("<li/>"
        style: "line-height:#{@options.path_height}px"
        text: item.label
      )
