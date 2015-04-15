gulp = require("gulp")
gutil = require("gulp-util")
extend = require("extend")
execSync = require("sync-exec")
os = require("os")

module.exports = new class GulpConfig
  constructor: ->
    @_GLOBALS_DEFAULTS = {
      defaults: {
        BUNDLE_VERSION: "1.0.0"

        # Change to "1" if you want to use Crosswalk on Android.
        #
        # NOTE See hooks/after_platform_add/020_migrate_android_to_crosswalk.sh ,
        #      to configure it first.
        # NOTE You need to recreate platforms/android/ project whenever you change it
        #      (by running `run `gulp cordova:clear`).
        ANDROID_CROSSWALK_MODE: "0"

        AVAILABLE_PLATFORMS: ["ios", "android"]

        # The name of your angular app you're going to use in `angular.module("")`
        ANGULAR_APP_NAME: "voicerepublic"

        # Base path to this project's directory. Generated automatically.
        APP_ROOT: execSync("pwd").stdout.trim() + "/"

        # By default, we compile all html/css/js files into www/ directory.
        BUILD_DIR: (GLOBALS) ->
          if !!+GLOBALS.TMP_BUILD_DIR
            "#{os.tmpdir()}/ionic#{GLOBALS.DEPLOY_TIME}/"
          else
            "www"

        # However, you can set this flag to true, and we'll change BUILD_DIR to a random directory.
        # Could be useful f.e. in unit/e2e tests
        TMP_BUILD_DIR: false

        # Should we compress assets (.css and .js files, soon also images)?
        COMPRESS_ASSETS: false

        # Marks the current code version. Used in uploading sourcemaps to Rollbar.
        # By default: sha-code of the recent git commit.
        CODE_VERSION: execSync("git rev-parse HEAD").stdout.trim()

        # This is only for convenience.
        # It will equal to "android" or "ios",
        # while the gulp is running a task building the app for given platform
        CORDOVA_PLATFORM: null

        # Current timestamp, used to get rid of unwanted http 304 requests.
        DEPLOY_TIME: Date.now()

        # Used in server/weinre tasks as an actual IP for the server.
        HTTP_SERVER_IP: (->
          # Try to detect IP address in user's network.
          # If not, fallback to 127.0.0.1 .
          localIp = execSync("(ifconfig wlan 2>/dev/null || ifconfig en0) | grep inet | grep -v inet6 | awk '{print $2}' | sed 's/addr://g'").stdout.trim()
          localIp = "127.0.0.1" unless parseInt(localIp) > 0
          localIp
        )()

        # By default, application runs on :4400 port.
        HTTP_SERVER_PORT: 4400

        # Optionally, you can define a proxy server:
        #   all requests to "http://localhost:4400/api/xxx"
        #   will be redirected to "https://ionic.starter.com/xxx"
        # PROXY_ADDRESS: "https://ionic.starter.com"
        # PROXY_ROUTE: "/api"

        # If true, we'll open the app in the browser after running the server.
        OPEN_IN_BROWSER: true

        # Report errors to Rollbar (rollbar.com)
        ROLLBAR_CLIENT_ACCESS_TOKEN: "a6fc227c9ba742ca92f7dca6a4cc2cba"
        ROLLBAR_SERVER_ACCESS_TOKEN: "9689cb351f8d43ea94be888c19971698"

        # If you want to upload sourcemaps to Rollbar, just set a random URL prefix
        # (we'll modify payloads on iOS/Android so the URL to js scripts will be always the same)
        ROLLBAR_SOURCEMAPS_URL_PREFIX: "https://voicerepublic.com"

        # Important: leave it as false, even if you want to have the sourcemaps uploaded.
        # gulp.task("deploy:rollbar-sourcemaps") automatically sets it as true - only when it's needed.
        # (you want to upload them only on release tasks, don't you?)
        UPLOAD_SOURCEMAPS_TO_ROLLBAR: false

        # If defined, we'll deploy the app to testfairy after compiling the release.
        TESTFAIRY_API_KEY: "c7010fcf08d326cd4994331726a41b8510117da2"
        # We will need that for our iOS apps.
        # TESTFAIRY_APP_TOKEN: "2074627b46c471f1daad428fee7a8d8708ee8912"
        # TESTFAIRY_TESTER_GROUPS: "IonicStarterTesters"
      },

      development: {
        ENV: "development"

        BUNDLE_ID: "com.voicerepublic.mobile.development"
        BUNDLE_NAME: "voicerepublic"

        # Automatically connect to weinre on application's startup
        # (this way you can debug your application on your PC even if it's running from mobile ;) )
        WEINRE_ADDRESS: (GLOBALS) ->
          "#{GLOBALS.HTTP_SERVER_IP}:31173"
      },

      production: {
        ENV: "production"

        BUNDLE_ID: "com.voicerepublic.mobile"
        BUNDLE_NAME: "voicerepublic"

        COMPRESS_ASSETS: true

        # If those 2 variables are defined, the app will be deployed to the remote server after compiling the release.
        # ANDROID_DEPLOY_APPBIN_PATH: "deploy@ionicstarter.com:/u/apps/ionicstarter/shared/public/uploads/ionicstarter-production.apk"
        # ANDROID_DEPLOY_APPBIN_URL: "http://ionicstarter.com/uploads/ionicstarter-production.apk"

        # If those 2 variables are defined, the app will be deployed to the remote server after compiling the release.
        # IOS_DEPLOY_APPBIN_PATH: "deploy@ionicstarter.com:/u/apps/ionicstarter/shared/public/uploads/ionicstarter-production.ipa"
        # IOS_DEPLOY_APPBIN_URL: "http://ionicstarter.com/uploads/ionicstarter-production.ipa"

        # Required for the release to be signed with correct certificate.
        IOS_PROVISIONING_PROFILE: "keys/ios/voicerepublicstaging.mobileprovision"

        # CORDOVA_GOOGLE_ANALYTICS_ID: "UA-123123-2"
        # GOOGLE_ANALYTICS_ID: "UA-123123-1"
        # GOOGLE_ANALYTICS_HOST: "ionicstarter.com"
      }
    }

    # _PUBLIC_GLOBALS_KEYS defines which @GLOBALS
    #   will be actually passed into the frontend's application.
    #   (rest of globals are visible only in gulp and shell scripts)
    #
    # The filtered globals will be available under GulpConfig.PUBLIC_GLOBALS.
    @_PUBLIC_GLOBALS_KEYS = [
      "ANGULAR_APP_NAME"
      "BUNDLE_NAME"
      "BUNDLE_VERSION"
      "CODE_VERSION"
      "CORDOVA_GOOGLE_ANALYTICS_ID"
      "DEPLOY_TIME"
      "ENV"
      "GOOGLE_ANALYTICS_HOST"
      "GOOGLE_ANALYTICS_ID"
      "ROLLBAR_CLIENT_ACCESS_TOKEN"
      "ROLLBAR_SOURCEMAPS_URL_PREFIX"
      "WEINRE_ADDRESS"
    ]

    # _SHELL_GLOBALS_KEYS defines which @GLOBALS
    #   will be passed to some of the shell tasks (f.e. those in tasks/cordova.coffee).
    #
    # The filtered globals will be available under GulpConfig.SHELL_GLOBALS.
    @_SHELL_GLOBALS_KEYS = [
      "ANDROID_CROSSWALK_MODE"
      "BUNDLE_ID"
      "BUNDLE_NAME"
      "BUNDLE_VERSION"
      "IOS_PROVISIONING_PROFILE"
    ]

    @_regenerateGlobals()

    @PATHS = {
      assets: ['assets/**', '!assets/**/*.ejs']
      assets_ejs: ['assets/**/*.ejs']
      watched_assets: ['assets/fonts/**', 'assets/images/**', 'assets/js/**', '!assets/*.ejs']
      styles: ['app/css/**/*.scss']
      scripts:
        vendor: [
          "assets/components/ionic/release/js/ionic.js"
          "assets/components/angular/angular.js"
          "assets/components/angular-animate/angular-animate.js"
          "assets/components/angular-sanitize/angular-sanitize.js"
          "assets/components/angular-ui-router/release/angular-ui-router.js"
          "assets/components/ionic/release/js/ionic-angular.js"

          # Here add any vendor files that should be included in vendor.js
          "assets/components/ngCordova/dist/ng-cordova.js"

          # Google Analytics support (for both in-browser and Cordova app)
          "assets/components/angulartics/src/angulartics.js"
          "assets/components/angulartics/src/angulartics-ga.js"
          "assets/components/angulartics/src/angulartics-ga-cordova.js"
        ]
        app: [
          'app/js/config/**/*.coffee' # initialize & configure the angular's app
          'app/js/*/**/*.coffee'      # include all angular submodules (like controllers, directives, services)
          'app/js/routes.coffee'      # app.config - set routes
        ]
        tests:
          e2e: [
            'test/e2e/*_test.coffee'
          ]
      templates: ['app/templates/**/*.jade']
      views: ['app/**/*.jade', '!app/templates/**/*.jade']
    }

    @DESTINATIONS = {
      assets: "#{@GLOBALS.BUILD_DIR}"
      styles: "#{@GLOBALS.BUILD_DIR}/css"
      scripts: "#{@GLOBALS.BUILD_DIR}/js"
      views: "#{@GLOBALS.BUILD_DIR}"
      livereload: [
        "#{@GLOBALS.BUILD_DIR}/**/*"
        "!#{@GLOBALS.BUILD_DIR}/**/*.map"
        "!#{@GLOBALS.BUILD_DIR}/config.xml"
      ]
      unnecessary_assets: [
        "#{@GLOBALS.BUILD_DIR}/**/*.map"
      ]
    }


  updateGlobalsDefaults: (GLOBALS_DEFAULTS) ->
    extend true, @_GLOBALS_DEFAULTS, GLOBALS_DEFAULTS
    @_regenerateGlobals()


  filterPublicGlobals: (@_PUBLIC_GLOBALS_KEYS) ->
    @PUBLIC_GLOBALS = {}
    for key in @_PUBLIC_GLOBALS_KEYS
      @PUBLIC_GLOBALS[key] = @GLOBALS[key] if @GLOBALS[key]?


  filterShellGlobals: (@_SHELL_GLOBALS_KEYS) ->
    @SHELL_GLOBALS = {}
    for key in @_SHELL_GLOBALS_KEYS
      @SHELL_GLOBALS[key] = @GLOBALS[key] if @GLOBALS[key]?


  _regenerateGlobals: ->
    @GLOBALS = require('extend') true, {}, @_GLOBALS_DEFAULTS.defaults, (@_GLOBALS_DEFAULTS[gutil.env.env || "development"] || {})

    Object.keys(@GLOBALS).forEach (k) =>
      # You can replace any of @GLOBALS by defining ENV variable in your command line,
      # f.e. `BUNDLE_ID="com.different.bundleid" gulp`
      @GLOBALS[k] = process.env[k] if process.env[k]? && @GLOBALS[k]?

      # You can also do this in this way:
      # `gulp --BUNDLE_ID="com.different.bundleid"`
      @GLOBALS[k] = gulp.env[k] if gulp.env[k]? && @GLOBALS[k]?

      # Last but not least, if a @GLOBALS[k] is a function,
      # then let's define it as a dynamic getter
      #
      # More information: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/defineProperty
      if typeof @GLOBALS[k] == "function"
        getter = @GLOBALS[k]
        Object.defineProperty @GLOBALS, k, get: => getter(@GLOBALS)

    @filterPublicGlobals(@_PUBLIC_GLOBALS_KEYS)
    @filterShellGlobals(@_SHELL_GLOBALS_KEYS)
