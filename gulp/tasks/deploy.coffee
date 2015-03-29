gulp = require('gulp-help')(require('gulp'))
shell = require 'gulp-shell'

{GLOBALS, PUBLIC_GLOBALS, PATHS, DESTINATIONS} = require "../config"


# Deploy the release's binary to webserver.
open_qrcode_cmd = (url) ->
  "curl -s --include \
  --request GET 'https://pierre2106j-qrcode.p.mashape.com/api?type=text&text=#{encodeURIComponent(url)}&ecl=L%20%7C%20M%7C%20Q%20%7C%20H&pixel=8&forecolor=000000&backcolor=ffffff' \
  --header \"X-Mashape-Authorization: xWzeUXHELgVCXp9L4iK3epFzvsTECUai\" | tail -n 1 | xargs open"


deploy_release_cmd = (from, to, to_url) ->
  "scp \
    #{from} #{to} \
    && echo \"App has been deployed to #{to_url} .\"\
    " + (if +GLOBALS.OPEN_IN_BROWSER then " && #{open_qrcode_cmd(to_url)}" else "")


# Android deployment
androidDeployReleaseTasks = []
androidReleaseFile = "platforms/android/ant-build/CordovaApp-release.apk"


if GLOBALS.TESTFAIRY_API_KEY
  gulp.task "deploy:testfairy:android", "Deploy the .apk binary file to TestFairy", shell.task("""
    env \
    TESTFAIRY_API_KEY='#{GLOBALS.TESTFAIRY_API_KEY}' \
    TESTER_GROUPS='#{GLOBALS.TESTFAIRY_TESTER_GROUPS}' \
    utils/testfairy-upload-android.sh #{androidReleaseFile}
  """)
  androidDeployReleaseTasks.push "deploy:testfairy:android"


if GLOBALS.ANDROID_DEPLOY_APPBIN_PATH
  cmd = deploy_release_cmd androidReleaseFile, GLOBALS.ANDROID_DEPLOY_APPBIN_PATH, GLOBALS.ANDROID_DEPLOY_APPBIN_URL
  gulp.task "open-deploy:server:android", shell.task(open_qrcode_cmd(GLOBALS.ANDROID_DEPLOY_APPBIN_URL))
  gulp.task "deploy:server:android", "Deploy the .apk binary to #{GLOBALS.ANDROID_DEPLOY_APPBIN_PATH}", shell.task(cmd)
  androidDeployReleaseTasks.push "deploy:server:android"


gulp.task "deploy:release:android", "Deploy the Android app", androidDeployReleaseTasks



# IOS deployment
iosDeployReleaseTasks = []
iosReleaseFile = "platforms/ios/#{GLOBALS.BUNDLE_NAME}.ipa"


if GLOBALS.TESTFAIRY_API_KEY
  gulp.task "deploy:testfairy:ios", "Deploy the .ipa binary file to TestFairy", shell.task("""
    env \
    TESTFAIRY_API_KEY='#{GLOBALS.TESTFAIRY_API_KEY}' \
    TESTER_GROUPS='#{GLOBALS.TESTFAIRY_TESTER_GROUPS}' \
    utils/testfairy-upload-ios.sh #{iosReleaseFile}
  """)
  iosDeployReleaseTasks.push "deploy:testfairy:ios"


if GLOBALS.IOS_DEPLOY_APPBIN_PATH
  cmd = deploy_release_cmd iosReleaseFile, GLOBALS.IOS_DEPLOY_APPBIN_PATH, GLOBALS.IOS_DEPLOY_APPBIN_URL
  gulp.task "deploy:server:ios", "Deploy the .ipa binary file to #{GLOBALS.IOS_DEPLOY_APPBIN_PATH}", shell.task(cmd)
  iosDeployReleaseTasks.push "deploy:server:ios"

gulp.task "deploy:release:ios", "Deploy the iOS app", iosDeployReleaseTasks
