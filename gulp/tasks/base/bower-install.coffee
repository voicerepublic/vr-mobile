gulp = require('gulp-help')(require('gulp'))
shell = require 'gulp-shell'

gulp.task 'bower:install', "Run `bower install` to ensure bower packages are up-to-date", shell.task('bower install')
