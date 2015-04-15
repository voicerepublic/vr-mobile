{GLOBALS, PUBLIC_GLOBALS, _GLOBALS_DEFAULTS, SHELL_GLOBALS, PATHS, DESTINATIONS} = require "../config"


truncate = (string, length = 50, delimiter = '...') ->
  if !string || string.toString().length <= length
    string
  else
    string.toString().slice(0, length - delimiter.length) + delimiter


opt = {}
opt["env=#{Object.keys(_GLOBALS_DEFAULTS).slice(1).join("|")}"] = "Defines the environment for all gulp tasks and generated GLOBALS variables"
for k,v of GLOBALS
  opt[truncate("#{k}=#{v}", 55)] = "a GLOBAL variable"


# Configure `gulp help` task
gulp = require('gulp-help')(require('gulp'), {
  description: """
    Display this help text. NOTE: All argument options described below are applied to all of gulp tasks.
  """
  options: opt
})
