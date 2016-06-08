var gulp = require('gulp'),
    shell = require('gulp-shell'),
    del = require('del'),
    elm = require('gulp-elm'),
    browserSync = require('browser-sync')
    .create(),
    src = ['elm/**/*.elm', '../main/elm/**/*.elm'],
    noop = function() {};
// internal tasks
gulp.task('elm-init', elm.init);
// external tasks
gulp.task('clean', function() {
    return del(['elm-stuff', 'target']);
});
gulp.task('compile', ['elm-init'], function() {
    return gulp.src('elm/TestRunner.elm')
        .pipe(elm.make({
            filetype: 'js',
            warn: true
        }))
        .pipe(gulp.dest('target'));
});
gulp.task('test', ['compile'], () => {
    return gulp.src('target/TestRunner.js')
        .pipe(shell(
            ['node target/TestRunner.js']
        ));
});
gulp.task('package', ['compile'], noop);
gulp.task('watch', ['test'], function() {
    gulp.watch(src, ['test']);
});
gulp.task('default', ['watch'], noop);;
