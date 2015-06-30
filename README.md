# Voicerepublic Mobile [![Circle CI](https://circleci.com/gh/munen/voicerepublic_mobile/tree/integration.svg?style=svg&circle-token=c40bfd4f3ded798fe2f51ee5751812d5c19ffebd)](https://circleci.com/gh/munen/voicerepublic_mobile/tree/integration)
Cross platform mobile app for voicerepublic.com, based on ionic & cordova.

## Base functionallity:
* Login: Authorization (Based on sessions or oauth)
* Register: In-App Browser, where the user can register on the main voicerepublic.com site.
* Record a talk: Provide functionallity to record a talk and store it locally.
* List of talks: Show a list of talks, where the user can choose to listen, organize and upload.
* Save a talk: Uploading and saving of a specified talk.
* Share on social networks: Simple as it is..^^

## How we share our app for testing & pivoting purpose (system testing)
[Ionic.view] (http://view.ionic.io/) and [Testfairy](http://testfairy.com) to share our apps with testers and clients,
 or to easily test on new devices.

## Dev Process
SCRUM is organized via [pivotaltracker](https://www.pivotaltracker.com/projects/1303582)

# Dev Features
* Application can be run in a local http server, or emulated/released to Android/iOS
* A lot of useful gulp tasks, like:
  * `gulp` - watch for changes + browser-sync (http server with livereload) + weinre debugger
  * `gulp cordova:emulate:ios` - run application in iOS emulator
  * `gulp cordova:run:android` - run application on Android's device
  * Run `gulp help` or see `gulp/tasks.coffee` for more information about all tasks
* Useful hooks and tweaks, which allow you to deploy your cordova app out-of-the-box
* SASS + CoffeeScript + Jade combo
* Support for multiple environments, like *development, staging, production* (configuration available in `gulpfile.coffee`)
* Tests configured and working: unit (karma + mocha) and end to end (protractor)
* Rollbar support (configured, working in angular functions and support for uploading the sourcemaps to Rollbar server)

# Requirements
* NodeJS
* Cordova 4.2+
* Android or iOS SDK installed and [configured](http://docs.phonegap.com/en/4.0.0/guide_platforms_index.md.html#Platform%20Guides) (required only if you want to deploy the app to native mobile platforms - you can run `gulp` server without that)

# Prerequisites
1. Install Node: `nvm install 0.12.2`
1. Install the Ionic CLI: `npm install -g ionic@1.4.3`
2. Install gulp: `npm install -g gulp@3.8.11`
3. Install cordova: `npm install -g cordova@4.3.0`
4. Install iOS Simulator: `npm install -g ios-sim@3.1.1`
5. Install iOS Deploy: `npm install -g ios-deploy`

# Getting Started
```
# install dependencies
npm install
bower install
brew install imagemagick # or `apt-get install imagemagick`, if you're on linux

gulp build

## Running in browser
ionic serve # if node v0.12.0 think about sudo ionic serve or sudo gulp serve

```
If you get "too many files" error, try: `ulimit -n 10000`. You may want to add this line to your .bashrc / .zshrc / config.fish.

## What does the `gulp build` do?

More or less:

* All .scss, .coffee, .jade files from `app/` will be compiled and copied to `www/`
* All `.ejs` files from `assets/` will be compiled to `www/`.
* All other files from `assets/` will be copied to `www/`.

For detailed description, see `gulpfile.coffee`.

P.S. `www/` is like `dist/` directory for Cordova. That's why it's not included in this repository, as it's fully generated with `gulp`.

## Testing

Requirements: installed PhantomJS and configured [selenium standalone webdriver](https://github.com/angular/protractor/blob/master/docs/getting-started.md#setup-and-config).

#### Unit tests (karma & PhantomJS/Chrome)

```
gulp test:unit # using PhantomJS
gulp test:unit --browsers Chrome # or using Google Chrome
```

#### e2e tests (protractor & selenium)

```
gulp build # build solution
gulp serve # served at :4400 port
node_modules/.bin/webdriver-manager start # runs selenium server in the background

gulp test:e2e # finally, run e2e tests
```

# How to run on mobile?

I recommend [tmux](http://tmux.sourceforge.net/) for handling multiple terminal tabs/windows ;)

1. Copy `.envrc.android-sample` or `.envrc.ios-sample` to `.envrc` and configure it.

  * Ofcourse, if you're a Mac user and you can compile both Android and iOS on the same machine, you can include all the variables from both of these files in only one `.envrc` .

  * Also, make sure you have all the keys and certificates needed stored in `keys/android/` and `keys/ios/`:

    * `keys/android/ionicstarter.keystore`
    * `keys/ios/ionicstarter_staging.mobileprovision`
    * `keys/ios/ionicstarter_production.mobileprovision`

2. Ensure, you have [configured ios/android platform with Cordova](http://cordova.apache.org/docs/en/edge/guide_cli_index.md.html), f.e. by running `gulp cordova:platform-add:[ios|android]`.

3. Run `gulp cordova:emulate:[ios|android]` or `gulp cordova:run:[ios|android]`.

# Releasing to appstores

First, generate the certificate keys:

#### Android

1. [Generate .keystore file](http://developer.android.com/tools/publishing/app-signing.html):
`keytool -genkey -v -keystore keys/android/$ANDROID_KEYSTORE_NAME.keystore -alias $ANDROID_ALIAS_NAME -keyalg RSA -keysize 2048 -validity 10000`

#### iPhone

1. Create a certificate and a provisioning profile, as it's described [here](http://docs.build.phonegap.com/en_US/3.3.0/signing_signing-ios.md.html#iOS%20Signing).

2. Download the provisioning profile and copy it into `keys/ios/`, so it will match the `IOS_PROVISIONING_PROFILE` file set up in the `gulpfile.coffee`.

Then, generate the application and deploy it to the webserver with:

```
gulp release:[ios|android] --env=[staging|production]
```
