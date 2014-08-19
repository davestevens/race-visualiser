define ["underscore"], (_) ->
  LapMarker =
    lap_marker_colour: "#8D8D8D"
    lap_marker_big_tick: 0
    lap_marker_big_tick_width: 2
    lap_marker_label_height: 20

  RacerLabel =
    racer_label_width: 150
    racer_label_active_colour: "#0000FF"

  RacerPath =
    racer_path_height: 20
    racer_path_x_padding: 30
    racer_path_default_colour: "#8D8D8D"
    racer_path_width: 3
    racer_path_width_highlight: 6

  RacerPosition =
    racer_position_marker_size: 10
    racer_position_font_colour: "#000000"

  Options =
    font_family: "Helvetica, sans-serif"

  _.extend(Options, LapMarker, RacerLabel, RacerPath, RacerPosition)
