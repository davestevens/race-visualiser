requirejs.config
  baseUrl: "js/app"
  paths:
    underscore: "../lib/underscore"
  shim:
    underscore: { exports: "_" }

require ["race_visualiser"], (RaceVisualiser) ->
  race_visualiser = new RaceVisualiser
    el: document.getElementById("race_visualiser")
    data: data

  race_visualiser.render()
