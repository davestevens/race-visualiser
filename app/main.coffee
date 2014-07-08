requirejs.config
  paths:
    underscore: "../node_modules/underscore/underscore"
  shim:
    underscore: { exports: "_" }

require ["race_visualiser"], (RaceVisualiser) ->
  race_visualiser = new RaceVisualiser
    el: document.getElementById("race_visualiser")
    data: data

  race_visualiser.render()
