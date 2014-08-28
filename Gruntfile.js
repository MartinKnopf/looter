module.exports = function (grunt) {
  grunt.initConfig({
    browserify: {
      watchClient: {
        src: ['looter.js'],
        dest: 'bundle.js',
        options: {
          alias: ['looter.js:./looter', 'node_modules/rx/index.js:rx'],
          watch: false
        }
      }
    },

    watch: {
      browserify: {
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
          {src: ['./**'], dest: '/'}
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