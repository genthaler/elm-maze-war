var gulp = require('gulp'),
    del = require('del'),
    shell = require('gulp-shell'),
    ghPages = require('gulp-gh-pages'),
    browserSync = require('browser-sync')
    .create();
require('gulp-submodule')(gulp);
var main = gulp.submodule('main', {
    filepath: "main"
});
var test = gulp.submodule('test', {
    filepath: "test"
});
gulp.task('main-clean', shell.task('gulp clean', {
    cwd: 'main'
}));
gulp.task('test-clean', shell.task('gulp clean', {
    cwd: 'test'
}));
gulp.task('clean', ['main:clean', 'test:clean']);
gulp.task('compile', ['main:compile', 'test:compile']);
gulp.task('test', ['test:test']);
gulp.task('main-default', shell.task('gulp', {
    cwd: 'main'
}))
gulp.task('test-default', shell.task('gulp', {
    cwd: 'test'
}));
gulp.task('default', ['main-default', 'test-default'], function() {});
gulp.task('deploy', function() {
    return gulp.src('./dist/**/*')
        .pipe(ghPages());
});
