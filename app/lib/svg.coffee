define ["underscore"], (_) ->
  class Svg
    element: (type, attributes, styles) ->
      _.tap(@_namespaced_element(type), (element) ->
        element.setAttribute(name, value) for name, value of attributes
        element.style[name] = value for name, value of styles
      )

    line_to_curve: (source, target, offset = { x: 0, y: 0 }) ->
      path = "L#{source.x + offset.x},#{source.y}"
      path += @curve(arguments...)
      path

    # Modified from sankey.link
    # github d3/d3-plugins : blob/master/sankey/sankey.js
    curve: (source, target, offset = { x: 0, y: 0 }) ->
      x0 = source.x + offset.x
      x1 = target.x + offset.x

      x2 = x3 = @_interpolate_number(x0, x1)

      y0 = source.y
      y1 = target.y

      "C#{x2},#{y0} #{x3},#{y1} #{x1},#{y1}"

    # Modified from d3.interpolateNumber
    # github mbostock/d3 : blob/master/src/interpolate/number.js
    _interpolate_number: (a, b) ->
      curvature = 0.5
      a + (b - a) * curvature

    _namespaced_element: (type) ->
      document.createElementNS("http://www.w3.org/2000/svg", type)

  new Svg
