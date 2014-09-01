module.exports = function (grunt) {
  grunt.initConfig({
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

  grunt.registerTask('buildNW', [
    'compress:nodeWebkit'
  ]);
};