gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
changed = require 'gulp-changed'
ejs = require 'gulp-ejs'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


gulp.task 'assets:ejs', "Compile assets/*.ejs files and copy them to ./#{GLOBALS.BUILD_DIR}/", ->
  gulp.src(PATHS.assets_ejs)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))
    .pipe(ejs(GLOBALS, ext: ''))
    .pipe(gulp.dest(DESTINATIONS.assets))

gulp.task 'assets:others', "Copy assets/* files to ./#{GLOBALS.BUILD_DIR}/", ->
  gulp.src(PATHS.assets, base: "assets")
    .pipe(changed(DESTINATIONS.assets))
    .pipe(gulp.dest(DESTINATIONS.assets))

gulp.task 'assets', "Copy assets files to ./#{GLOBALS.BUILD_DIR}/", ['assets:ejs', 'assets:others']
