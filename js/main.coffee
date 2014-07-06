requirejs.config
  baseUrl: "js/app"
  paths:
    underscore: "../lib/underscore"
    backbone: "../lib/backbone"
    jquery: "../lib/jquery-2.1.1"
  shim:
    backbone:
      deps: ["jquery", "underscore"]
      exports: "Backbone"
    underscore:
      exports: "_"

require ["jquery", "race_visualiser"], ($, RaceVisualiser) ->
  race_visualiser = new RaceVisualiser
    el: "#race_visualiser"
    data: data

  race_visualiser.render()
