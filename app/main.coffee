requirejs.config
  paths:
    underscore: "../node_modules/underscore/underscore"
  shim:
    underscore: { exports: "_" }

require ["race_visualiser"], (RaceVisualiser) ->
  race_visualiser = new RaceVisualiser
    el: document.getElementById("race_visualiser")
    data: data
    options: { lap_marker_big_tick: data.splits }

  race_visualiser.render()
