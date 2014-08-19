define ["jquery"], ($) ->
  class ControlsView
    constructor: (options) ->
      @laps = options.laps
      @splits = options.splits
      @start = options.start
      @end = options.end

    render: ->
      $("<div/>", class: "controls")
        .append(@_start_lap())
        .append(@_end_lap())
        .append(@_button())
        .append(@_position_toggle())

    _start_lap: ->
      $("<div/>", class: "start_lap")
        .append($("<label/>", text: "Start", for: "js-start_lap"))
        .append(@_select("js-start_lap").val(@start))

    _end_lap: ->
      $("<div/>", class: "end_lap")
        .append($("<label/>", text: "End", for: "js-end_lap"))
        .append(@_select("js-end_lap").val(@end))

    _button: -> $("<button/>", class: "js-change-view", text: "Update")

    _position_toggle: ->
      $("<div/>", class: "position_toggle")
        .append($("<label/>", text: "Hide Position Markers", for: "js-position-toggle"))
        .append($("<input/>", type: "checkbox", id: "js-position-toggle"))

    _select: (class_name) ->
      $select = $("<select/>", class: class_name)
      for lap in [0..@laps]
        $("<option />", value: lap * @splits, text: @_lap_text(lap))
          .appendTo($select)
      $select

    _lap_text: (number) ->
      return "Grid" if number == 0
      "Lap #{number}"