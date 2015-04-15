gulp = require('gulp-help')(require('gulp'))
runSequence = require 'run-sequence'

{GLOBALS, PATHS, DESTINATIONS} = require "../config"


gulp.task "default", "Build ./#{GLOBALS.BUILD_DIR}/ contents, run browser-sync server and watch for changes (and rebuild & livereload, when something changes).", (cb) ->
  runSequence "build", ["watch", "serve", "weinre"], cb
