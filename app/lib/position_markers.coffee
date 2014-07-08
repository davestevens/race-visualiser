define ["lib/options", "lib/svg"], (Options, Svg) ->
  class PositionMarkers
    constructor: ->
      @group = Svg.element("g", class: "positions", fill: "black")

    build: (point, label) ->
      marker = _.tap(Svg.element("g"), (element) =>
        element.appendChild(@_marker(point))
        element.appendChild(@_text(point, label))
      )
      @group.appendChild(marker)

    _marker: (point) ->
      attributes =
        cx: point.x + Options.horizontal_padding
        cy: point.y
        r: Options.position_marker_size
      styles =
        strokeWidth: "1px"
        fill: "white"

      Svg.element("circle", attributes, styles)

    _text: (point, label) ->
      attributes =
        x: point.x + Options.horizontal_padding
        y: point.y
      styles =
        fontSize: "14px"
        textAnchor: "middle"
        dominantBaseline: "middle"
        stroke: "black"
        strokeWidth: "0";

      _.tap(Svg.element("text", attributes, styles), (element) =>
        element.textContent = label
      )
