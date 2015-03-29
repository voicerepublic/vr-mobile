gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
sourcemaps = require 'gulp-sourcemaps'
rollbar = require 'gulp-rollbar'
gulpIf = require 'gulp-if'
uglify = require 'gulp-uglify'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


uploadSourcemapsToRollbar = ->
  shouldUploadRollbarSourcemaps = !!+GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR && !!GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN
  gulpIf(shouldUploadRollbarSourcemaps, rollbar({
    accessToken: (GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN ? "none")
    version: GLOBALS.CODE_VERSION
    sourceMappingURLPrefix: GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX + "/js"
  }))


gulp.task 'scripts:vendor', "Compile vendor js scripts to the ./#{GLOBALS.BUILD_DIR}/js/vendor.js file", ->
  gulp.src(PATHS.scripts.vendor)

    .pipe(sourcemaps.init())
      .pipe(concat('vendor.js'))
      .pipe(gulpIf(!!+GLOBALS.COMPRESS_ASSETS, uglify(mangle: false)))
      .pipe(uploadSourcemapsToRollbar())
    .pipe(sourcemaps.write('./'))

    .pipe(gulp.dest(DESTINATIONS.scripts))


gulp.task "scripts:app", "Compile ./app/js/*.js scripts to the ./#{GLOBALS.BUILD_DIR}/js/app.js file", ->
  gulp.src(PATHS.scripts.app)
    .pipe((plumber (error) ->
      gutil.log gutil.colors.red(error.message)
      @emit('end')
    ))

    .pipe(sourcemaps.init())
      .pipe(coffee())
      .pipe(concat("app.js"))
      .pipe(gulpIf(!!+GLOBALS.COMPRESS_ASSETS, uglify(mangle: false)))
      .pipe(uploadSourcemapsToRollbar())
    .pipe(sourcemaps.write('./'))

    .pipe(gulp.dest(DESTINATIONS.scripts))


gulp.task 'scripts', "Compile ./#{GLOBALS.BUILD_DIR}/js/*.js scripts", ['scripts:vendor', 'scripts:app']


if !!GLOBALS.ROLLBAR_SERVER_ACCESS_TOKEN
  # Run this as a first task, to enable uploading sourcemaps to rollbar.
  # By default it's being run in the "release" task.
  gulp.task "deploy:rollbar-sourcemaps:enable", "Turn on uploading of scripts' sourcemaps to Rollbar (during the scripts:* tasks)", ->
    GLOBALS.UPLOAD_SOURCEMAPS_TO_ROLLBAR = true

  gulp.task "deploy:rollbar-sourcemaps", "Upload scripts' sourcemaps to Rollbar", ["deploy:rollbar-sourcemaps:enable", "scripts"]
