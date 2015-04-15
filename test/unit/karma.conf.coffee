BUILD_DIR = process.env.BUILD_DIR ? "www"

module.exports = (config) ->
  config.set
    basePath: '../../'
    frameworks: ['mocha', 'chai', 'chai-as-promised', 'sinon-chai', 'chai-things']

    # list of files / patterns to load in the browser
    files: [
      "#{BUILD_DIR}/js/vendor.js"
      "assets/components/angular-mocks/angular-mocks.js"

      "test/unit/tests-config.coffee"

      # "#{BUILD_DIR}/js/app.js"
      # This is a concatenated list of all scripts from gulpfile.coffee
      # (we need to keep it up to date with it).
      "#{BUILD_DIR}/js/app_templates.js"
      'app/js/config/**/*.coffee'
      'app/js/*/**/*.coffee'
      'app/js/routes.coffee'

      "test/unit/helpers/**/*.coffee"
      "test/unit/**/*.coffee"
    ]

    exclude: [
      "test/unit/karma.conf.coffee"
    ]

    # use dots reporter, as travis terminal does not support escaping sequences
    # possible values: 'dots', 'progress', 'osx', 'ubuntu'
    # CLI --reporters progress
    reporters: ['osx', 'dots', 'progress', 'coverage', 'junit']

    coverageReporter: {type: 'text'}

    junitReporter:
      outputFile: 'test-results.xml'

    autoWatch: true

    # f.e. Chrome, PhantomJS
    browsers: ['PhantomJS']

    preprocessors:
      '**/*.coffee': ['coffee']
      'app/features/*/*.coffee': ['coverage']

    coffeePreprocessor:
      options:
        bare: false
        sourceMap: true

      # transformPath: (path) ->
      #   path.replace(/\.coffee$/, '.js')
