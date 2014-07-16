var minimatch = require('minimatch');
module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON("package.json"),

    coffee: {
      compile: {
        options: { bare: true },
        expand: true,
        flatten: false,
        cwd: "app/",
        src: ["**/*.coffee"],
        dest: "js/",
        ext: ".js"
      }
    },

    watch: {
      options: {
        nospawn: true
      },
      coffee: {
        files: "app/**/*.coffee",
        tasks: ["coffee:compile"]
      }
    },

    requirejs: {
      compile: {
        options: {
          baseUrl: "js",
          paths: {
            underscore: "../node_modules/underscore/underscore",
            jquery: "../node_modules/jquery/dist/jquery"
          },
          name: "../node_modules/almond/almond",
          include: "race_visualiser",
          out: "dist/race_visualiser.min.js",
          wrap: {
            startFile: "module_wrappers/wrap-start.frag.js",
            endFile: "module_wrappers/wrap-end.frag.js"
          }
        }
      },
      dev: {
        options: {
          baseUrl: "js",
          paths: {
            underscore: "../node_modules/underscore/underscore",
            jquery: "../node_modules/jquery/dist/jquery"
          },
          name: "../node_modules/almond/almond",
          include: "race_visualiser",
          optimize: "none",
          out: "dist/race_visualiser.js",
          wrap: {
            startFile: "module_wrappers/wrap-start.frag.js",
            endFile: "module_wrappers/wrap-end.frag.js"
          }
        }
      }

    }
  });

  grunt.loadNpmTasks("grunt-contrib-coffee");
  grunt.loadNpmTasks("grunt-contrib-watch");
  grunt.loadNpmTasks('grunt-contrib-requirejs');

  grunt.event.on("watch", function (action, filepath) {
    var file_name;
    if (minimatch(filepath, grunt.config("watch.coffee.files"))) {
      // Remove coffee.compile.cwd path from string
      file_name = filepath.substring(4);
      grunt.config("coffee.compile.src", [file_name]);
    }
  });

  grunt.registerTask("default", ["coffee:compile"]);
  grunt.registerTask("release", ["coffee:compile","requirejs:bare"]);
};
