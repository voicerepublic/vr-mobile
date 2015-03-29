gulp = require('gulp-help')(require('gulp'))
runSequence = require 'run-sequence'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


# Run 'set-debug' as the first task, to enable debug version.
# Example: `gulp set-debug cordova:run:android`
gulp.task "set-debug", false, ->
  if GLOBALS.BUNDLE_ID.indexOf(".debug") == -1
    GLOBALS.BUNDLE_ID += ".debug"
    GLOBALS.BUNDLE_NAME += "Dbg"


gulp.task "build-debug", false, ["set-debug", "build"]


gulp.task "build", "Compile all the contents of ./#{GLOBALS.BUILD_DIR}/", (cb) ->
  runSequence ["clean", "bower:install"],
    [
      "assets"
      "styles"
      "scripts"
      "templates"
      "views"
    ], cb


gulp.task "build-release", false, (cb) ->
  runSequence "build", "build:minify", cb
