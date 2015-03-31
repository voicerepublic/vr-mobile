gulp = require('gulp-help')(require('gulp'))
childProcess = require 'child_process'
extend = require("extend")
runSequence = require 'run-sequence'
os = require 'os'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"


gulp.task "build-test", false, (cb) ->
  runSequence ["clean"],
    [
      "scripts"
      "templates"
    ], cb


gulp.task 'watch-test', false, ->
  gulp.watch(PATHS.scripts.app, ['scripts:app'])
  gulp.watch(PATHS.scripts.vendor, ['scripts:vendor'])
  gulp.watch(PATHS.templates, ['templates'])


# Runs unit tests using karma.
# You can run it simply using `gulp test:unit`.
# You can also pass some karma arguments like this: `gulp test:unit --browsers Chrome`.
#
# NOTE if you want to run simultaneously `gulp` and `gulp test:unit` in 2 terminals,
#   you can have some bugs with karma turning off its' watchers when `gulp` cleans the build directory.
#   To solve this, instead run `gulp test:unit --TMP_BUILD_DIR=1`,
#   so karma will be building its' files into a different, temporary directory.

gulp.task 'test:unit',
  "Run unit tests",
  ["build-test", "watch-test"],
  ->
    args = ['start', 'test/unit/karma.conf.coffee']
    for name in ['browsers', 'reporters']
      args.push "--#{name}", "#{gulp.env[name]}" if gulp.env.hasOwnProperty(name)

    childProcess.spawn "node_modules/.bin/karma", args,
      stdio: 'inherit'
      env: extend({}, process.env, BUILD_DIR: GLOBALS.BUILD_DIR)
  , {
    options:
      "browsers=chrome,PhantomJS": "(passed directly to Karma)"
      "reporters=osx,progress": "(passed directly to Karma)"
  }

# Another unit test task especially for CircleCI with --signle-run
gulp.task 'test:unit:single',
  "Single run unit tests",
  ["build-test"],
  ->
    args = ['start', 'test/unit/karma.conf.coffee', '--single-run']
    childProcess.spawn "node_modules/.bin/karma", args,
      stdio: 'inherit'
      env: extend({}, process.env, BUILD_DIR: GLOBALS.BUILD_DIR)