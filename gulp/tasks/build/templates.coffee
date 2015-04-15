gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
plumber = require 'gulp-plumber'
notify = require 'gulp-notify'
jade = require 'gulp-jade'
templateCache = require 'gulp-angular-templatecache'
path = require 'path'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'templates', "Compile ./app/templates/*.jade templates to a ./#{GLOBALS.BUILD_DIR}/js/app_templates.js file", ->
  gulp.src(PATHS.templates)
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

    .pipe(templateCache("app_templates.js", {
      standalone: true
      module: "#{GLOBALS.ANGULAR_APP_NAME}.templates"
      base: (file) ->
        file.path
          .replace(path.resolve("./"), "")
          .replace("/app/", "")
    }))
    .pipe(gulp.dest(DESTINATIONS.scripts))
