gulp = require('gulp-help')(require('gulp'))
clean = require 'gulp-clean'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


gulp.task 'build:minify',
  "Minify ./#{GLOBALS.BUILD_DIR}/ files size by compressing them and removing unnecessary ones.",
  ['build:remove-unnecessary-assets']


gulp.task 'build:remove-unnecessary-assets', "Remove unnecessary assets from ./#{GLOBALS.BUILD_DIR}/.", ->
  gulp.src(DESTINATIONS.unnecessary_assets, read: false)
    .pipe(clean(force: true))
