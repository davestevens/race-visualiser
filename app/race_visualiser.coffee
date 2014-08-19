define [
  "jquery"
  "lib/options"
  "lib/svg"
  "lib/style"
  "lib/utils"
  "views/lap_markers"
  "views/race"
  "views/controls"
], ($, Options, Svg, Style, Utils, LapMarkersView, RaceView, ControlsView) ->
  class RaceVisualiser
    constructor: (params) ->
      _.extend(Options, params.options)
      @data = params.data
      @el = params.el

      throw new Error "Please define data" unless @data

      @_generate_ids()

    render: (options = {}) ->
      @start = options.start || 0
      @end = options.end || (@data.splits * @data.laps)

      @_sort_racers(@end)

      $(@el).html(@build())
      $(@el).append(@_controls().render())
      @_after_render()

     build: ->
      @splits = @end - @start
      throw new Error "Invalid start and end laps" if @splits <= 0

      attributes = { width: @_calculate_width(), height: @_full_height() }
      svg = Svg.element("svg", attributes)
      _.tap(svg, (element) =>
        element.appendChild(@_style().build())

        element.appendChild(@_lap_markers().build())
        element.appendChild(@_race().build())
      )

    _generate_ids: ->
      _.each(@data.racers, (racer, index) -> racer.id = index)

    _sort_racers: (index) ->
      @data.racers = _.sortBy(@data.racers, (racer) ->
        racer.positions[index] || racer.positions[-1..][0]
      )

    _controls: ->
      new ControlsView(
        laps: @data.laps, splits: @data.splits
        start: @start, end: @end
      )

    _after_render: ->
      $("#paths").bind("mouseover", ".path", @_mouseover_path)
      $("#paths").bind("mouseout", ".path", @_mouseout_path)
      $("#labels").bind("click", ".label", @_click_label)
      $(".position_toggle").bind("change", "input", @_toggle_position_markers)
      $(".js-change-view").bind("click", @_change_view)

    _toggle_position_markers: (event) =>
      $positions = $("#positions")
      if $(event.target).is(":checked")
        Utils.add_class($positions, "hidden")
      else
        Utils.remove_class($positions, "hidden")

    _mouseover_path: (event) =>
      $path = $(event.target).parent()
      racer = $path.data("racer")
      $position = $("#positions .#{racer}")
      $paths = $("#paths")

      Utils.add_active_class([$path, $position, $paths])
      $path.parent().append($path)

    _mouseout_path: (event) =>
      $path = $(event.target).parent()
      racer = $path.data("racer")
      $position = $("#positions .#{racer}")

      @_remove_path_highlight($path, $position)
      @_remove_paths_highlight()

    _click_label: (event) =>
      racer = $(event.target).data("racer")
      $label = $("#labels .#{racer}")
      $path = $("#paths .#{racer}")
      $position = $("#positions .#{racer}")
      $paths = $("#paths")

      if _.contains($path.attr("class").split(/\s+/), "active")
        Utils.remove_active_class([$label])
        @_remove_path_highlight($path, $position)
        @_remove_paths_highlight()
      else
        Utils.add_active_class([$label, $path, $position, $paths])

    _remove_path_highlight: ($path, $position) ->
      racer = $path.data("racer")
      $label = $("#labels .#{racer}")
      return if _.contains($label.attr("class").split(/\s+/), "active")
      Utils.remove_active_class([$path, $position])

    _remove_paths_highlight: ->
      $paths = $("#paths")
      Utils.remove_active_class([$paths]) if @_no_active_labels()

    _no_active_labels: -> $("#labels .active").length == 0

    _change_view: =>
      start = +$(".js-start_lap").val()
      end = +$(".js-end_lap").val()
      return alert("Invalid Lap selection") if (start >= end)
      @render(start: start, end: end)

    _style: -> new Style()

    _lap_markers: ->
      new LapMarkersView(
        start: @start, end: @end, height: @_height(), dx: @_dx()
      )

    _race: ->
      new RaceView(
        width: @_width(), height: @_height(), dx: @_dx()
        racers: @data.racers, start: @start, end: @end
      )

    _width: ->
      (Options.width || @_calculate_width()) - Options.racer_label_width

    _full_height: -> @_height() + Options.lap_marker_label_height
    _height: -> (@data.racers.length + 1) * Options.racer_path_height

    _dx: -> (@_width() - (2 * Options.racer_path_x_padding)) / @splits

    # Using .offsetWidth or .width() returns a rounded pixel value
    _calculate_width: -> Math.floor(@el.getBoundingClientRect().width)
