define('lib/options',["underscore"], function(_) {
  var LapMarker, Options, RacerLabel, RacerPath, RacerPosition;
  LapMarker = {
    lap_marker_colour: "#8D8D8D",
    lap_marker_big_tick: 0,
    lap_marker_big_tick_width: 2,
    lap_marker_label_height: 20
  };
  RacerLabel = {
    racer_label_width: 150
  };
  RacerPath = {
    racer_path_height: 20,
    racer_path_x_padding: 30,
    racer_path_default_colour: "#8D8D8D",
    racer_path_width: 3,
    racer_path_width_highlight: 6
  };
  RacerPosition = {
    racer_position_marker_size: 10,
    racer_position_font_colour: "#000000"
  };
  Options = {
    font_family: "Helvetica, sans-serif"
  };
  return _.extend(Options, LapMarker, RacerLabel, RacerPath, RacerPosition);
});

define('lib/svg',["underscore"], function(_) {
  var Svg;
  Svg = (function() {
    function Svg() {}

    Svg.prototype.element = function(type, attributes, styles) {
      return _.tap(this._namespaced_element(type), function(element) {
        var name, value, _results;
        for (name in attributes) {
          value = attributes[name];
          element.setAttribute(name, value);
        }
        _results = [];
        for (name in styles) {
          value = styles[name];
          _results.push(element.style[name] = value);
        }
        return _results;
      });
    };

    Svg.prototype.line_to_curve = function(source, target, offset) {
      var path;
      if (offset == null) {
        offset = {
          x: 0,
          y: 0
        };
      }
      path = "L" + (source.x + offset.x) + "," + source.y;
      path += this.curve.apply(this, arguments);
      return path;
    };

    Svg.prototype.curve = function(source, target, offset) {
      var x0, x1, x2, x3, y0, y1;
      if (offset == null) {
        offset = {
          x: 0,
          y: 0
        };
      }
      x0 = source.x + offset.x;
      x1 = target.x + offset.x;
      x2 = x3 = this._interpolate_number(x0, x1);
      y0 = source.y;
      y1 = target.y;
      return "C" + x2 + "," + y0 + " " + x3 + "," + y1 + " " + x1 + "," + y1;
    };

    Svg.prototype._interpolate_number = function(a, b) {
      var curvature;
      curvature = 0.5;
      return a + (b - a) * curvature;
    };

    Svg.prototype._namespaced_element = function(type) {
      return document.createElementNS("http://www.w3.org/2000/svg", type);
    };

    return Svg;

  })();
  return new Svg;
});

define('lib/style',["underscore", "lib/options", "lib/svg"], function(_, Options, Svg) {
  var Style;
  return Style = (function() {
    function Style(options) {
      _.extend(this.options, options);
    }

    Style.prototype.build = function() {
      var defs, style,
        _this = this;
      defs = Svg.element("defs");
      style = Svg.element("style", {
        type: "text/css"
      });
      _.tap(style, function(element) {
        return element.textContent = _this.options.styles.join("\n");
      });
      defs.appendChild(style);
      return defs;
    };

    Style.prototype.options = {
      styles: ["svg { font-family: " + Options.font_family + "; }", "#lap_markers .marker {" + " stroke-width: 1px;" + " opacity: 0.5;" + (" stroke: " + Options.lap_marker_colour) + "}", "#lap_markers .number {" + " font-size: 14px;" + " text-anchor: middle;" + " stroke: #000000;" + " stroke-width: 0" + "}", "#lap_markers .big {" + " opacity: 0.7;" + (" stroke-width: " + Options.lap_marker_big_tick_width + "px") + "}", "#paths { fill: none }", "#paths .path {" + (" stroke-width: " + Options.racer_path_width + "px;") + " opacity: 0.6;" + "}", "#paths:hover .path { opacity: 0.3; }", "#paths .path.active {" + " opacity: 1;" + " cursor: pointer;" + (" stroke-width: " + Options.racer_path_width_highlight + "px") + "}", "#paths .path .dnf { stroke-dasharray: 10,5 }", "#positions .position { display: none; }", "#positions .position .marker_text {" + " font-size: 14px;" + " text-anchor: middle;" + " stroke: #000000;" + " stroke-width: 0" + "}", "#positions .position .marker_circle {" + " stroke-width: 1px;" + " fill: #FFFFFF" + "}"]
    };

    return Style;

  })();
});

define('views/laps/markers',["lib/options", "lib/svg"], function(Options, Svg) {
  var LapMarkers;
  return LapMarkers = (function() {
    function LapMarkers(options) {
      this.height = options.height;
      this.dx = options.dx;
      this.splits = options.splits;
    }

    LapMarkers.prototype.build = function() {
      var markers, _i, _ref, _results,
        _this = this;
      markers = this._markers();
      _.each((function() {
        _results = [];
        for (var _i = 0, _ref = this.splits; 0 <= _ref ? _i <= _ref : _i >= _ref; 0 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this), function(index) {
        return markers.appendChild(_this._marker(index));
      });
      return markers;
    };

    LapMarkers.prototype._markers = function() {
      return Svg.element("g", {
        id: "markers"
      });
    };

    LapMarkers.prototype._marker = function(index) {
      var attributes, x;
      x = (this.dx * index) + Options.racer_path_x_padding;
      attributes = {
        "class": "marker",
        x1: x,
        y1: 0,
        x2: x,
        y2: this.height
      };
      if (!(index % Options.lap_marker_big_tick)) {
        attributes["class"] += " big";
      }
      return Svg.element("line", attributes);
    };

    return LapMarkers;

  })();
});

define('views/laps/numbers',["lib/options", "lib/svg"], function(Options, Svg) {
  var LapNumbers;
  return LapNumbers = (function() {
    function LapNumbers(options) {
      this.height = options.height;
      this.dx = options.dx;
      this.start = options.start;
      this.end = options.end;
    }

    LapNumbers.prototype.build = function() {
      var index, label, numbers, _i, _ref, _ref1, _ref2;
      numbers = this._numbers();
      for (index = _i = _ref = this.start, _ref1 = this.end, _ref2 = Options.lap_marker_big_tick; _ref2 > 0 ? _i <= _ref1 : _i >= _ref1; index = _i += _ref2) {
        if (index === 0) {
          continue;
        }
        label = index / Options.lap_marker_big_tick;
        numbers.appendChild(this._number(index - this.start, label));
      }
      return numbers;
    };

    LapNumbers.prototype._numbers = function() {
      return Svg.element("g", {
        id: "lap_number"
      });
    };

    LapNumbers.prototype._number = function(index, label) {
      var attributes, x;
      x = (this.dx * index) + Options.racer_path_x_padding;
      attributes = {
        "class": "number",
        x: x,
        y: this.height + Options.lap_marker_label_height / 2,
        dy: "0.3em"
      };
      return _.tap(Svg.element("text", attributes), function(element) {
        return element.textContent = label;
      });
    };

    return LapNumbers;

  })();
});

define('views/lap_markers',["underscore", "lib/options", "lib/svg", "views/laps/markers", "views/laps/numbers"], function(_, Options, Svg, LapMarkers, LapNumbers) {
  var LapMarkersView;
  return LapMarkersView = (function() {
    function LapMarkersView(options) {
      this.start = options.start;
      this.end = options.end;
      this.height = options.height;
      this.dx = options.dx;
    }

    LapMarkersView.prototype.build = function(ticks) {
      var _this = this;
      return _.tap(this._lap_markers(), function(element) {
        element.appendChild(_this._markers().build());
        return element.appendChild(_this._numbers().build());
      });
    };

    LapMarkersView.prototype._lap_markers = function() {
      return Svg.element("g", {
        id: "lap_markers"
      });
    };

    LapMarkersView.prototype._markers = function() {
      return new LapMarkers({
        height: this.height,
        dx: this.dx,
        splits: this.end - this.start
      });
    };

    LapMarkersView.prototype._numbers = function() {
      return new LapNumbers({
        height: this.height,
        dx: this.dx,
        start: this.start,
        end: this.end
      });
    };

    return LapMarkersView;

  })();
});

define('views/labels',["lib/options", "lib/svg"], function(Options, Svg) {
  var LabelsView;
  return LabelsView = (function() {
    function LabelsView(options) {
      this.width = options.width;
      this.height = options.height;
      this.x = options.x;
      this.racers = options.racers;
    }

    LabelsView.prototype.build = function() {
      var labels,
        _this = this;
      labels = this._labels();
      _.each(this.racers, function(racer, index) {
        return labels.appendChild(_this._label(index, racer));
      });
      return labels;
    };

    LabelsView.prototype._labels = function() {
      var attributes;
      attributes = {
        id: "labels",
        width: this.width,
        height: this.height,
        x: this.x
      };
      return Svg.element("svg", attributes);
    };

    LabelsView.prototype._label = function(index, racer) {
      var attributes;
      attributes = {
        "class": "label racer_" + racer.id,
        dy: "0.3em",
        x: 2,
        y: Options.racer_path_height + Options.racer_path_height * index
      };
      return _.tap(Svg.element("text", attributes), function(element) {
        return element.textContent = racer.label;
      });
    };

    return LabelsView;

  })();
});

define('lib/utils',["lib/options", "lib/svg"], function(Options, Svg) {
  var Utils;
  Utils = (function() {
    function Utils() {}

    Utils.prototype.each_cons = function(a, cons_size, fn) {
      var i, _i, _ref, _results;
      _results = [];
      for (i = _i = 0, _ref = a.length - cons_size; 0 <= _ref ? _i <= _ref : _i >= _ref; i = 0 <= _ref ? ++_i : --_i) {
        _results.push(fn(a.slice(i, +(i + (cons_size - 1)) + 1 || 9e9), i));
      }
      return _results;
    };

    Utils.prototype.stroke_colour = function(racer) {
      return racer.colour || Options.racer_path_default_colour;
    };

    Utils.prototype.position_to_coord = function(index, position, dx) {
      return {
        x: index * dx,
        y: position * Options.racer_path_height
      };
    };

    Utils.prototype.curve = function(a, b, index) {
      return Svg.line_to_curve(a, b, {
        x: Options.racer_path_x_padding
      });
    };

    return Utils;

  })();
  return new Utils();
});

define('views/paths',["lib/options", "lib/svg", "lib/utils"], function(Options, Svg, Utils) {
  var PathsView;
  return PathsView = (function() {
    function PathsView(options) {
      this.width = options.width;
      this.height = options.height;
      this.dx = options.dx;
      this.racers = options.racers;
      this.start = options.start;
      this.end = options.end;
    }

    PathsView.prototype.build = function() {
      var paths,
        _this = this;
      paths = this._paths();
      _.each(this.racers, function(racer) {
        return paths.appendChild(_this._path(racer));
      });
      return paths;
    };

    PathsView.prototype._paths = function() {
      var attributes;
      attributes = {
        id: "paths",
        width: this.width,
        height: this.height
      };
      return Svg.element("svg", attributes);
    };

    PathsView.prototype._start_path = function(position) {
      var start;
      start = this._position_to_coord(0, position);
      return "M" + start.x + "," + start.y;
    };

    PathsView.prototype._end_path = function(position, index) {
      var end, end_x, offset;
      end = this._position_to_coord(index, position);
      offset = this._has_finished(index) ? 2 : 1;
      end_x = end.x + (offset * Options.racer_path_x_padding);
      return "L" + end_x + "," + end.y;
    };

    PathsView.prototype._position_change = function(a, b, index) {
      var point_a, point_b;
      point_a = this._position_to_coord(index, a);
      point_b = this._position_to_coord(index + 1, b);
      return Utils.curve(point_a, point_b, index + 1);
    };

    PathsView.prototype._get_positions = function(positions) {
      var _positions;
      _positions = positions.slice(this.start, +this.end + 1 || 9e9);
      if (_.isEmpty(_positions)) {
        return [positions[positions.length - 1]];
      }
      return _positions;
    };

    PathsView.prototype._path = function(racer) {
      var attributes, dnf_path, last_index, path, positions, style,
        _this = this;
      positions = this._get_positions(racer.positions);
      path = this._start_path(positions[0]);
      Utils.each_cons(positions, 2, function(_arg, index) {
        var a, b;
        a = _arg[0], b = _arg[1];
        if (a !== b && (b != null)) {
          return path += _this._position_change(a, b, index);
        }
      });
      last_index = positions.length - 1;
      path += this._end_path(positions[last_index], last_index);
      if (!this._has_finished(last_index)) {
        dnf_path = this._dnf(positions[last_index], last_index);
      }
      attributes = {
        "class": "path racer_" + racer.id,
        "data-racer": "racer_" + racer.id
      };
      style = {
        stroke: Utils.stroke_colour(racer)
      };
      return _.tap(Svg.element("g", attributes, style), function(element) {
        element.appendChild(Svg.element("path", {
          d: path
        }));
        if (dnf_path != null) {
          return element.appendChild(dnf_path);
        }
      });
    };

    PathsView.prototype._has_finished = function(index) {
      return index === (this.end - this.start);
    };

    PathsView.prototype._dnf = function(position, index) {
      var a, attributes, end, end_x;
      end = this._position_to_coord(index, position);
      a = ((this.end - this.start) * this.dx) + (2 * Options.racer_path_x_padding);
      end_x = end.x + (1 * Options.racer_path_x_padding);
      attributes = {
        d: "M" + end_x + "," + end.y + "L" + a + "," + end.y,
        "class": "dnf"
      };
      return Svg.element("path", attributes);
    };

    PathsView.prototype._position_to_coord = function(index, position) {
      return Utils.position_to_coord(index, position, this.dx);
    };

    return PathsView;

  })();
});

define('views/positions',["lib/options", "lib/svg", "lib/utils"], function(Options, Svg, Utils) {
  var PositionsView;
  return PositionsView = (function() {
    function PositionsView(options) {
      this.width = options.width;
      this.height = options.height;
      this.dx = options.dx;
      this.racers = options.racers;
      this.start = options.start;
      this.end = options.end;
    }

    PositionsView.prototype.build = function() {
      var positions,
        _this = this;
      positions = this._positions();
      _.each(this.racers, function(racer) {
        return positions.appendChild(_this._markers(racer));
      });
      return positions;
    };

    PositionsView.prototype._positions = function() {
      var attributes;
      attributes = {
        id: "positions",
        width: this.width,
        height: this.height
      };
      return Svg.element("svg", attributes);
    };

    PositionsView.prototype._get_positions = function(positions) {
      var _positions;
      _positions = positions.slice(this.start, +this.end + 1 || 9e9);
      if (_.isEmpty(_positions)) {
        return [positions[positions.length - 1]];
      }
      return _positions;
    };

    PositionsView.prototype._markers = function(racer) {
      var attributes, group, positions, styles,
        _this = this;
      attributes = {
        "class": "position racer_" + racer.id
      };
      styles = {
        stroke: Utils.stroke_colour(racer)
      };
      group = Svg.element("g", attributes, styles);
      positions = this._get_positions(racer.positions);
      group.appendChild(this._marker_and_text(0, positions));
      Utils.each_cons(positions, 2, function(_arg, index) {
        var a, b;
        a = _arg[0], b = _arg[1];
        if (a !== b && (b != null)) {
          return group.appendChild(_this._marker_and_text(index + 1, positions));
        }
      });
      group.appendChild(this._marker_and_text(positions.length - 1, positions));
      return group;
    };

    PositionsView.prototype._marker_and_text = function(index, positions) {
      var point, position,
        _this = this;
      position = positions[index];
      point = this._position_to_coord(index, position);
      return _.tap(Svg.element("g"), function(element) {
        element.appendChild(_this._marker(point, position));
        return element.appendChild(_this._text(point, position));
      });
    };

    PositionsView.prototype._marker = function(point, label) {
      var attributes;
      attributes = {
        "class": "marker_circle",
        cx: point.x + Options.racer_path_x_padding,
        cy: point.y,
        r: Options.racer_position_marker_size
      };
      return Svg.element("circle", attributes);
    };

    PositionsView.prototype._text = function(point, label) {
      var attributes;
      attributes = {
        "class": "marker_text",
        x: point.x + Options.racer_path_x_padding,
        y: point.y,
        dy: "0.3em"
      };
      return _.tap(Svg.element("text", attributes), function(element) {
        return element.textContent = label;
      });
    };

    PositionsView.prototype._position_to_coord = function(index, position) {
      return Utils.position_to_coord(index, position, this.dx);
    };

    return PositionsView;

  })();
});

define('views/race',["lib/options", "lib/svg", "views/labels", "views/paths", "views/positions"], function(Options, Svg, LabelsView, PathsView, PositionsView) {
  var RaceView;
  return RaceView = (function() {
    function RaceView(options) {
      this.racers = options.racers;
      this.width = options.width;
      this.height = options.height;
      this.start = options.start;
      this.end = options.end;
      this.dx = options.dx;
    }

    RaceView.prototype.build = function() {
      var _this = this;
      return _.tap(this._race(), function(element) {
        element.appendChild(_this._labels().build());
        element.appendChild(_this._paths().build());
        return element.appendChild(_this._positions().build());
      });
    };

    RaceView.prototype._race = function() {
      return Svg.element("g", {
        id: "race"
      });
    };

    RaceView.prototype._labels = function() {
      return new LabelsView({
        width: Options.racer_label_width,
        height: this.height,
        x: this.width,
        racers: this.racers
      });
    };

    RaceView.prototype._paths = function() {
      return new PathsView({
        width: this.width,
        height: this.height,
        dx: this.dx,
        racers: this.racers,
        start: this.start,
        end: this.end
      });
    };

    RaceView.prototype._positions = function() {
      return new PositionsView({
        width: this.width,
        height: this.height,
        dx: this.dx,
        racers: this.racers,
        start: this.start,
        end: this.end
      });
    };

    return RaceView;

  })();
});

define('views/controls',["jquery"], function($) {
  var ControlsView;
  return ControlsView = (function() {
    function ControlsView(options) {
      this.laps = options.laps;
      this.splits = options.splits;
      this.start = options.start;
      this.end = options.end;
    }

    ControlsView.prototype.render = function() {
      return $("<div/>").append(this._start_lap()).append(this._end_lap()).append(this._button());
    };

    ControlsView.prototype._start_lap = function() {
      return $("<div/>").append($("<label/>", {
        text: "Start",
        "for": "js-start_lap"
      })).append(this._select("js-start_lap").val(this.start));
    };

    ControlsView.prototype._end_lap = function() {
      return $("<div/>").append($("<label/>", {
        text: "End",
        "for": "js-end_lap"
      })).append(this._select("js-end_lap").val(this.end));
    };

    ControlsView.prototype._button = function() {
      return $("<button/>", {
        "class": "js-change-view",
        text: "Update"
      });
    };

    ControlsView.prototype._select = function(class_name) {
      var $select, lap, _i, _ref;
      $select = $("<select/>", {
        "class": class_name
      });
      for (lap = _i = 0, _ref = this.laps; 0 <= _ref ? _i <= _ref : _i >= _ref; lap = 0 <= _ref ? ++_i : --_i) {
        $("<option />", {
          value: lap * this.splits,
          text: this._lap_text(lap)
        }).appendTo($select);
      }
      return $select;
    };

    ControlsView.prototype._lap_text = function(number) {
      if (number === 0) {
        return "Grid";
      }
      return "Lap " + number;
    };

    return ControlsView;

  })();
});

define('race_visualiser',["jquery", "lib/options", "lib/svg", "lib/style", "views/lap_markers", "views/race", "views/controls"], function($, Options, Svg, Style, LapMarkersView, RaceView, ControlsView) {
  var RaceVisualiser;
  return RaceVisualiser = (function() {
    function RaceVisualiser(params) {
      _.extend(Options, params.options);
      this.data = params.data;
      this.el = params.el;
      if (!this.data) {
        throw new Error("Please define data");
      }
      this._generate_ids();
    }

    RaceVisualiser.prototype.render = function(options) {
      if (options == null) {
        options = {};
      }
      this.start = options.start || 0;
      this.end = options.end || (this.data.splits * this.data.laps);
      this._sort_racers(this.end);
      $(this.el).html(this.build());
      $(this.el).append(this._controls().render());
      return this._after_render();
    };

    RaceVisualiser.prototype.build = function() {
      var attributes, svg,
        _this = this;
      this.splits = this.end - this.start;
      if (this.splits <= 0) {
        throw new Error("Invalid start and end laps");
      }
      attributes = {
        width: this._calculate_width(),
        height: this._full_height()
      };
      svg = Svg.element("svg", attributes);
      return _.tap(svg, function(element) {
        element.appendChild(_this._style().build());
        element.appendChild(_this._lap_markers().build());
        return element.appendChild(_this._race().build());
      });
    };

    RaceVisualiser.prototype._generate_ids = function() {
      return _.each(this.data.racers, function(racer, index) {
        return racer.id = index;
      });
    };

    RaceVisualiser.prototype._sort_racers = function(index) {
      return this.data.racers = _.sortBy(this.data.racers, function(racer) {
        return racer.positions[index];
      });
    };

    RaceVisualiser.prototype._controls = function() {
      return new ControlsView({
        laps: this.data.laps,
        splits: this.data.splits,
        start: this.start,
        end: this.end
      });
    };

    RaceVisualiser.prototype._after_render = function() {
      _.bindAll(this, "_mouseover_path", "_mouseout_path", "_change_view");
      $("#paths").bind("mouseover", ".path", this._mouseover_path);
      $("#paths").bind("mouseout", ".path", this._mouseout_path);
      return $(".js-change-view").bind("click", this._change_view);
    };

    RaceVisualiser.prototype._mouseover_path = function(event) {
      var $path, racer;
      $path = $(event.target).parent();
      racer = $path.data("racer");
      this._add_class($path, "active");
      $path.parent().append($path);
      return $("#positions ." + racer).show();
    };

    RaceVisualiser.prototype._mouseout_path = function(event) {
      var $path, racer;
      $path = $(event.target).parent();
      racer = $path.data("racer");
      this._remove_class($path, "active");
      return $("#positions ." + racer).hide();
    };

    RaceVisualiser.prototype._change_view = function() {
      var end, start;
      start = +$(".js-start_lap").val();
      end = +$(".js-end_lap").val();
      if (start >= end) {
        return alert("Invalid Lap selection");
      }
      return this.render({
        start: start,
        end: end
      });
    };

    RaceVisualiser.prototype._add_class = function($element, class_name) {
      var classes;
      classes = "" + ($element.attr('class')) + " active";
      return $element.attr("class", classes);
    };

    RaceVisualiser.prototype._remove_class = function($element, class_name) {
      var classes;
      classes = $element.attr("class").replace(class_name, "");
      return $element.attr("class", classes);
    };

    RaceVisualiser.prototype._style = function() {
      return new Style();
    };

    RaceVisualiser.prototype._lap_markers = function() {
      return new LapMarkersView({
        start: this.start,
        end: this.end,
        height: this._height(),
        dx: this._dx()
      });
    };

    RaceVisualiser.prototype._race = function() {
      return new RaceView({
        width: this._width(),
        height: this._height(),
        dx: this._dx(),
        racers: this.data.racers,
        start: this.start,
        end: this.end
      });
    };

    RaceVisualiser.prototype._width = function() {
      return (Options.width || this._calculate_width()) - Options.racer_label_width;
    };

    RaceVisualiser.prototype._full_height = function() {
      return this._height() + Options.lap_marker_label_height;
    };

    RaceVisualiser.prototype._height = function() {
      return (this.data.racers.length + 1) * Options.racer_path_height;
    };

    RaceVisualiser.prototype._dx = function() {
      return (this._width() - (2 * Options.racer_path_x_padding)) / this.splits;
    };

    RaceVisualiser.prototype._calculate_width = function() {
      return Math.floor(this.el.getBoundingClientRect().width);
    };

    return RaceVisualiser;

  })();
});

