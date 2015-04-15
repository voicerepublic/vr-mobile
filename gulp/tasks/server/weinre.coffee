gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
open = require 'open'
childProcess = require 'child_process'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task "weinre", "Run a Weinre debugger server", ->
  [weinreHost, weinrePort] = GLOBALS.WEINRE_ADDRESS.split(":")

  args = ["--httpPort=#{weinrePort}", "--boundHost=#{weinreHost}"]
  child = childProcess.spawn "node_modules/.bin/weinre", args,
    stdio: "inherit"
  # .on "exit", (code) ->
  #   child.kill() if child
  #   cb(code)

  if +GLOBALS.OPEN_IN_BROWSER
    open("http://#{weinreHost}:#{weinrePort}/client/#anonymous")
    gutil.log gutil.colors.blue "Opening weinre debugger in the browser..."
