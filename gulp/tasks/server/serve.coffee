gulp = require('gulp-help')(require('gulp'))
gutil = require 'gulp-util'
browserSync = require 'browser-sync'
proxy = require "proxy-middleware"
url = require "url"

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../../config"

gulp.task 'serve', "Run browser-sync server with livereload in ./#{GLOBALS.BUILD_DIR}/ directory", ->
  middlewares = []

  if GLOBALS.PROXY_ADDRESS
    proxyOptions = url.parse(GLOBALS.PROXY_ADDRESS)
    proxyOptions.route = GLOBALS.PROXY_ROUTE
    middlewares.push proxy(proxyOptions)

  browserSync({
    server:
      baseDir: GLOBALS.BUILD_DIR
      middleware: middlewares
    port: GLOBALS.HTTP_SERVER_PORT
    open: !!+GLOBALS.OPEN_IN_BROWSER
    files: DESTINATIONS.livereload
  })
