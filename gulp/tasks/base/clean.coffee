gulp = require('gulp-help')(require('gulp'))
clean = require 'gulp-clean'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'clean', "Clean contents of ./#{GLOBALS.BUILD_DIR}/", ->
  gulp.src(GLOBALS.BUILD_DIR, read: false)
    .pipe(clean(force: true))
