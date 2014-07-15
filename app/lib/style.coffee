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
        "#lap_markers .marker { stroke-width: 1px; opacity: 0.5; stroke: #{Options.lap_marker_colour} }"
        "#lap_markers .big { stroke-width: #{Options.lap_marker_big_tick_width}px; opacity: 0.7 }"
        "#paths { fill: none }"
        "#paths .path { stroke-width: #{Options.racer_path_width}px; opacity: 0.6; }"
        "#paths:hover .path { opacity: 0.3; }"
        "#paths .path:hover { opacity: 1; stroke-width: #{Options.racer_path_width_highlight}px; cursor: pointer }"
        "#paths .path .dnf { stroke-dasharray: 10,5 }"
        "#positions .position { display: none; }"
        "#positions .position .marker_text { font-size: 14px; text-anchor: middle; stroke: #000000; stroke-width: 0 }"
        "#positions .position .marker_circle { stroke-width: 1px; fill: #FFFFFF }"
      ]
