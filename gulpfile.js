var gulp = require('gulp'),
    del = require('del'),
    shell = require('gulp-shell'),
    browserSync = require('browser-sync')
    .create();
require('gulp-submodule')(gulp);
var main = gulp.submodule('main', {
    filepath: "src/main"
});
var test = gulp.submodule('test', {
    filepath: "src/test"
});
gulp.task('clean-main', shell.task('gulp clean', {
    cwd: 'src/main'
}));
gulp.task('clean-test', shell.task('gulp clean', {
    cwd: 'src/test'
}));

gulp.task('clean', ['clean-main', 'clean-test']);

gulp.task('compile', ['main:compile'], function() {});
gulp.task('test-compile', ['compile', 'test:compile'], function() {});
gulp.task('test', ['test-compile', 'test:test'], function() {});
gulp.task('run', ['main:default'], function() {});
gulp.task('run-tests', ['main:compile', 'test:default'], function() {});
gulp.task('default', ['main:default', 'test:default'], function() {});
