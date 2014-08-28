module.exports = function (grunt) {
  grunt.initConfig({
    browserify: {

      //working with grunt-watch - do NOT use with keepAlive above
      watchClient: {
        src: ['looter.js'],
        dest: 'bundle.js',
        options: {
          alias: ['looter.js:./looter', 'node_modules/rx/rx.node.js:rx'],
          watch: false
        }
      }
    },

    watch: {
      browserify: {
        //note that we target the OUTPUT file from watchClient, and don't trigger browserify
        //the module watching and rebundling is handled by watchify itself
        files: ['looter.js'],
        tasks: ['browserify:watchClient']
      },
    },

    compress: {
      nodeWebkit: {
        options: {
          archive: 'looter.zip',
          mode: 'zip'
        },
        files: [
          {src: ['./**'], dest: '/'}, // includes files in path
        ]
      }
    }

  });

  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-compress');

  grunt.registerTask('browserifyWithWatch', [
    'browserify:watchClient',
    'watch:browserify'
  ]);

  grunt.registerTask('buildNW', [
    'compress:nodeWebkit'
  ]);
};