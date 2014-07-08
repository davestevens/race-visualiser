define ["underscore", "lib/svg"], (_, Svg) ->
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
        "svg { font-family: Helvetica, sans-serif; }"
        "#paths path { opacity: 0.6; }"
        "#paths:hover.path path { opacity: 0.3; }"
        "#paths .path:hover { opacity: 1; stroke-width: 6px; cursor: pointer }"
        ".positions { display: none; }"
        "#paths .path:hover ~ .positions { display: block; }"
        "#paths .path:hover ~ .dnf { opacity: 1; }"
      ]
