define ["underscore", "lib/options", "lib/svg"], (_, Options, Svg) ->
  class Style
    constructor: (options) -> _.extend(@options, options)

    build: ->
      defs = Svg.element("defs")
      style = Svg.element("style", type: "text/css")
      _.tap(style, (element) =>
        element.textContent = @options.styles.join("\n")
      )
      defs.appendChild(style)
      defs

    options:
      styles: [
        "svg { font-family: #{Options.font_family}; }"
        "#lap_markers .marker {" +
          " stroke-width: 1px;" +
          " opacity: 0.5;" +
          " stroke: #{Options.lap_marker_colour}" +
          "}"
        "#lap_markers .number {" +
          " font-size: 14px;" +
          " text-anchor: middle;" +
          " stroke: #000000;" +
          " stroke-width: 0" +
          "}"
        "#lap_markers .big {" +
          " opacity: 0.7;" +
          " stroke-width: #{Options.lap_marker_big_tick_width}px" +
          "}"
        "#labels .label { cursor: pointer }"
        "#labels .label.active { fill: #{Options.racer_label_active_colour} }"
        "#paths { fill: none }"
        "#paths .path {" +
          " stroke-width: #{Options.racer_path_width}px;" +
          " opacity: 0.6;" +
          "}"
        "#paths.active .path { opacity: 0.3; }"
        "#paths .path.active {" +
          " opacity: 1;" +
          " cursor: pointer;" +
          " stroke-width: #{Options.racer_path_width_highlight}px" +
          "}"
        "#paths .path .dnf { stroke-dasharray: 10,5 }"
        "#positions.hidden { display: none; }"
        "#positions .position { display: none; }"
        "#positions .position.active { display: block; }"
        "#positions .position .marker_text {" +
          " font-size: 14px;" +
          " text-anchor: middle;" +
          " stroke: #000000;" +
          " stroke-width: 0" +
          "}"
        "#positions .position .marker_circle {" +
          " stroke-width: 1px;" +
          " fill: #FFFFFF" +
          "}"
      ]
