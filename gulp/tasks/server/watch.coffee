gulp = require('gulp-help')(require('gulp'))

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'watch', "Watch contents of app, assets, vendor files and recompile them to ./#{GLOBALS.BUILD_DIR}/ when changed", ->
  if process.env.GULP_WATCH_ASSETS # this makes some bug with descriptors on mac, so let's enable it only when specified ENV is defined
    gulp.watch(PATHS.assets, ['assets'])
  else
    gulp.watch(PATHS.watched_assets, ['assets'])
  gulp.watch(PATHS.assets_ejs, ['assets:ejs'])
  gulp.watch(PATHS.scripts.app, ['scripts:app'])
  gulp.watch(PATHS.scripts.vendor, ['scripts:vendor'])
  gulp.watch(PATHS.styles, ['styles'])
  gulp.watch(PATHS.templates, ['templates'])
  gulp.watch(PATHS.views, ['views'])
