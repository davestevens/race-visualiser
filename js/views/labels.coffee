define ["backbone"], (Backbone) ->
  LabelsView = Backbone.View.extend
    render: (index) ->
      $ordered_list = $("<ol/>")

      _.chain( @collection )
        .sortBy( (item) -> item.positions[index] )
        .each( (item) => $ordered_list.append(@_render_item(item)) )

      @$el.html($ordered_list)

    _render_item: (item) -> $("<li/>", text: item.label)
