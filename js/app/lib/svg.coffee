define ["underscore"], (_) ->
  class Svg
    element: (type, attributes, styles) ->
      _.tap(@_namespaced_element(type), (element) ->
        element.setAttribute(name, value) for name, value of attributes
        element.style[name] = value for name, value of styles
      )

    _namespaced_element: (type) ->
      document.createElementNS("http://www.w3.org/2000/svg", type)

  new Svg
