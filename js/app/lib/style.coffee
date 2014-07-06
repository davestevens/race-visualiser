define ["underscore", "lib/svg"], (_, Svg) ->
  class Style
    constructor: (options) -> _.extend(@options, options)

    build: ->
      style = Svg.element("style")
      _.tap(style, (element) =>
        element.textContent = @options.styles.join("\n")
      )

    options:
      styles: [
        "#paths path { opacity: 0.6; }"
        "#paths:hover path { opacity: 0.3; }"
        "#paths path:hover { opacity: 1; stroke-width: 6px; cursor: pointer }"
      ]
