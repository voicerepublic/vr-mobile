gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
changed = require 'gulp-changed'
notify = require 'gulp-notify'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
gulpIf = require 'gulp-if'
minifyCSS = require 'gulp-minify-css'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'styles', "Compile ./app/css/*.sass stylesheets to ./#{GLOBALS.BUILD_DIR}/css/*.css", ->
  gulp.src(PATHS.styles)
    .pipe(changed(DESTINATIONS.styles, extension: '.css'))
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))

    .pipe(sourcemaps.init())
      .pipe(sass())
      .pipe(gulpIf(!!+GLOBALS.COMPRESS_ASSETS, minifyCSS(processImport: false)))
    .pipe(sourcemaps.write('./'))

    .on('error', notify.onError((error) -> error.message))
    .pipe(gulp.dest(DESTINATIONS.styles))
