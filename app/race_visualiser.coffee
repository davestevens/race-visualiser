define [
  "jquery"
  "lib/options"
  "lib/svg"
  "lib/style"
  "views/lap_markers"
  "views/race"
  "views/controls"
], ($, Options, Svg, Style, LapMarkersView, RaceView, ControlsView) ->
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

      svg = Svg.element("svg", width: @_calculate_width(),
        height: @_full_height())
      _.tap(svg, (element) =>
        element.appendChild(@_style().build())

        element.appendChild(@_lap_markers().build())
        element.appendChild(@_race().build())
      )

    _generate_ids: ->
      _.each(@data.racers, (racer, index) -> racer.id = index)

    _sort_racers: (index) ->
      @data.racers = _.sortBy(@data.racers, (racer) -> racer.positions[index])

    _controls: ->
      new ControlsView(
        laps: @data.laps, splits: @data.splits
        start: @start, end: @end
      )

    _after_render: ->
      _.bindAll(@, "_mouseover_path", "_mouseout_path", "_change_view")
      $("#paths").bind("mouseover", ".path", @_mouseover_path)
      $("#paths").bind("mouseout", ".path", @_mouseout_path)
      $(".js-change-view").bind("click", @_change_view)

    _mouseover_path: (event) ->
      $path = $(event.target).parent()
      racer = $path.data("racer")

      @_add_class($path, "active")
      $path.parent().append($path)
      $("#positions .#{racer}").show()

    _mouseout_path: (event) ->
      $path = $(event.target).parent()
      racer = $path.data("racer")

      @_remove_class($path, "active")
      $("#positions .#{racer}").hide()

    _change_view: ->
      start = +$(".js-start_lap").val()
      end = +$(".js-end_lap").val()
      return alert("Invalid Lap selection") if (start >= end)
      @render(start: start, end: end)

    _add_class: ($element, class_name) ->
      classes = "#{$element.attr('class')} active"
      $element.attr("class", classes)

    _remove_class: ($element, class_name) ->
      classes = $element.attr("class").replace(class_name, "")
      $element.attr("class", classes)

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
