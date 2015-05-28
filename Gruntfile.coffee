module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-uglify')
  grunt.loadNpmTasks('grunt-contrib-watch')
  grunt.loadNpmTasks('grunt-release')
  grunt.loadNpmTasks('grunt-ng-annotate')

  grunt.config.init
    pkg: grunt.file.readJSON "package.json"
    coffee:
      default:
        files:
          "build/angular-global-spinner.js": "src/angular-global-spinner.coffee"
    ngAnnotate:
      build:
        files:[{
          src: 'build/<%= pkg.name %>.js'
          dest: 'build/<%= pkg.name %>.js'}]
    uglify:
      options:
        banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
      build:
        src: 'build/<%= pkg.name %>.js'
        dest: 'build/<%= pkg.name %>.min.js'
    release:
      options:
        npm: false
    watch:
      scripts:
        files: ['src/*']
        tasks: ['default']

  grunt.registerTask "default", ["coffee", "ngAnnotate", "uglify"]
