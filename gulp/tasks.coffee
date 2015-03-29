require "./tasks/base/clean"
require "./tasks/base/bower-install"

require "./tasks/build/assets"
require "./tasks/build/styles"
require "./tasks/build/scripts"
require "./tasks/build/templates"
require "./tasks/build/views"
require "./tasks/build/minify"
require "./tasks/build/build"

require "./tasks/test/e2e"
require "./tasks/test/unit"

require "./tasks/server/watch"
require "./tasks/server/serve"
require "./tasks/server/weinre"

require "./tasks/cordova"

require "./tasks/deploy"
require "./tasks/release"

require "./tasks/help"
require "./tasks/default"
