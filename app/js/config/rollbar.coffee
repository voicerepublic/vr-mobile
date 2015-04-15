return unless window.Rollbar?
app = angular.module(GLOBALS.ANGULAR_APP_NAME)


app.factory '$exceptionHandler', ($log) ->
  (e, cause) ->
    $log.error e.message
    Rollbar.error(e)


Rollbar.configure
  payload:
    deploy_time: GLOBALS.DEPLOY_TIME
    deploy_date: new Date(GLOBALS.DEPLOY_TIME).toDateString()
    bundle_name: GLOBALS.BUNDLE_NAME
    bundle_version: GLOBALS.BUNDLE_VERSION

  transform: (payload) ->
    if frames = payload.data?.body?.trace?.frames
      for frame in frames
        frame.filename = frame.filename.replace(GLOBALS.APP_ROOT, "#{GLOBALS.ROLLBAR_SOURCEMAPS_URL_PREFIX}/")


app.run (Auth) ->
  Auth.on "user.updated", (user) ->
    Rollbar.configure
      payload:
        person: ({
          id: user.id
          email: user.email
        } if user)

### future usage
app.run (onRouteChangeCallback) ->
  onRouteChangeCallback (state) ->
    Rollbar.configure
      payload:
        context: state.name
###