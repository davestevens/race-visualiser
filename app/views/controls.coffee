define ["jquery"], ($) ->
  class ControlsView
    constructor: (options) ->
      @laps = options.laps
      @splits = options.splits
      @start = options.start
      @end = options.end

    render: ->
      $("<div/>")
        .append(@_start_lap())
        .append(@_end_lap())
        .append(@_button())

    _start_lap: ->
      $("<div/>")
        .append($("<label/>", text: "Start", for: "js-start_lap"))
        .append(@_select("js-start_lap").val(@start))

    _end_lap: ->
      $("<div/>")
        .append($("<label/>", text: "End", for: "js-end_lap"))
        .append(@_select("js-end_lap").val(@end))

    _button: -> $("<button/>", class: "js-change-view", text: "Update")

    _select: (class_name) ->
      $select = $("<select/>", class: class_name)
      for lap in [0..@laps]
        $("<option />", value: lap * @splits, text: @_lap_text(lap))
          .appendTo($select)
      $select

    _lap_text: (number) ->
      return "Grid" if number == 0
      "Lap #{number}"