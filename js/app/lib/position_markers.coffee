define ["lib/svg"], (Svg) ->
  class PositionMarkers
    constructor: (options) ->
      _.extend(@options, options)
      @group = Svg.element("g", class: "positions", fill: "black")

    options:
      size: 10

    build: (point, label) ->
      marker = _.tap(Svg.element("g"), (element) =>
        element.appendChild(@_marker(point))
        element.appendChild(@_text(point, label))
      )
      @group.appendChild(marker)

    _marker: (point) ->
      attributes =
        cx: point.x + @options.horizontal_padding
        cy: point.y
        r: @options.size
      styles =
        strokeWidth: "1px"
        fill: "white"

      Svg.element("circle", attributes, styles)

    _text: (point, label) ->
      attributes =
        x: point.x + @options.horizontal_padding
        y: point.y
      styles =
        fontSize: "15px"
        textAnchor: "middle"
        dominantBaseline: "central"
        stroke: "black"
        strokeWidth: "0.5px";

      _.tap(Svg.element("text", attributes, styles), (element) =>
        element.textContent = label
      )
