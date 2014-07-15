define ["lib/options", "lib/svg"], (Options, Svg) ->
  class LabelsView
    constructor: (options) ->
      @width = options.width
      @height = options.height
      @x = options.x
      @racers = options.racers

    build: ->
      labels = @_labels()
      _.each(@racers, (racer, index) =>
        labels.appendChild(@_label(index, racer))
      )
      labels

    _labels: ->
      attributes = { id: "labels", width: @width, height: @height, x: @x }
      Svg.element("svg", attributes)

    _label: (index, racer) ->
      attributes =
        class: "label racer_#{racer.id}", dy: "0.3em"
        x: 2, y: (Options.racer_path_height + Options.racer_path_height * index)

      _.tap(Svg.element("text", attributes), (element) ->
        element.textContent = racer.label
      )
