gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
notify = require 'gulp-notify'
protractor = require 'gulp-protractor'
Q = require 'q'
childProcess = require 'child_process'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

phantomChild = null
phantomDefer = null

# standalone test server which runs in the background.
# doesnt work atm - instead, run `webdriver-manager start`
gulp.task 'test:e2e:server', "Run e2e server", (cb) ->
  return cb() if phantomDefer
  phantomDefer = Q.defer()

  phantomChild = childProcess.spawn('phantomjs', ['--webdriver=4444'], {
  })
  phantomChild.stdout.on 'data', (data) ->
    gutil.log gutil.colors.yellow data.toString()
    if data.toString().match 'running on port '
      phantomDefer.resolve()

  phantomChild.once 'close', ->
    gutil.log "phantomChild closed"
    phantomChild.kill() if phantomChild
    phantomDefer.reject()

  phantomChild.on 'exit', (code) ->
    gutil.log "phantomChild exitted"
    phantomChild.kill() if phantomChild

  phantomDefer.promise

# You can run it like this:
# `gulp test:e2e` - runs all e2e tests
# `gulp test:e2e --debug --specs test/e2e/intro_test.coffee` - runs only one test, in debug mode
gulp.task 'test:e2e', "Run e2e tests (e2e server must be running)", ->
  args = ['--baseUrl', "http://localhost:#{GLOBALS.HTTP_SERVER_PORT}"]
  args.push 'debug' if gulp.env.debug

  protractorTests = PATHS.scripts.tests.e2e
  protractorTests = gulp.env.specs.split(',') if gulp.env.specs

  gulp.src(protractorTests)
    .pipe(protractor.protractor({
      configFile: "test/e2e/protractor.config.js",
      args: args
    }))
    .on('error', (notify.onError((error) -> error.message)))
, {
  options:
    "debug=0": "(passed directly to Protractor)"
    "specs=path_to_e2e_test.coffee": "(passed directly to Protractor)"
}
