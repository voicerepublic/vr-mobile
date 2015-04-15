gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
jade = require 'gulp-jade'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'views', "Compile ./app/*.jade views to ./#{GLOBALS.BUILD_DIR}/*.html", ->
  gulp.src(PATHS.views)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(jade({
      locals:
        GLOBALS: PUBLIC_GLOBALS
      pretty: true
    }))
    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(DESTINATIONS.views))
