# Race Visualiser

Display Race data in interactive graph

## Dependencies
- Underscore.js
 - Helper functions
- RequireJS
 - Organisation
 - Optimiser
- Almond
 - Builds stand alone module
- Grunt

Run `npm install` to install all required dependencies

## TODO
- [x] Bring Racer path to front on hover
- [x] Display Lap/Split Markers
- [] Controls View
 - [] Display data from Start to End (zoom)
 - [] Lap Markers (on/off)
 - [] Position Markers (on/off, default to off if `dx` < `position_marker_size`)
- [] Set colour for each Racer (predefined or auto generated?)

## Usage
Can be used as either AMD module or standalone js file.

## Compile
`grunt requirejs:compile`
Produce minified standalone file `dist/race_visualiser.min.js`.

`grunt requirejs:dev`
Produce `dist/race_visualiser.js`.

`grunt coffee`
Compile all CoffeeScript files within `app/` into `js/` directory.

`grunt watch`
Watch CoffeeScript files and run `grunt coffee` when modified.
