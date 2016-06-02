var gulp = require('gulp'),
    shell = require('gulp-shell'),
    del = require('del'),
    elm = require('gulp-elm'),
    browserSync = require('browser-sync')
    .create(),
    src = ['elm/**/*.elm', '../main/elm/**/*.elm'],
    browserSyncInit = function() {
        browserSync.init({
            server: {
                baseDir: "target",
                index: "TestRunner.html"
            },
            port: 5000,
            ui: {
                port: 5001
            }
        });
    },
    browserSyncReload = browserSync.reload,
    noop = function() {};
// internal tasks
gulp.task('elm-init', elm.init);
gulp.task('reload', browserSyncReload);
gulp.task('compile-and-reload', ['compile'], browserSyncReload);
gulp.task('pre-server', browserSyncInit);
// external tasks
gulp.task('clean', function() {
    return del(['elm-stuff', 'target']);
});
gulp.task('compile', ['elm-init'], function() {
    return gulp.src('elm/TestRunner.elm')
        .pipe(elm.make({
            filetype: 'html',
            warn: true
        }))
        .pipe(gulp.dest('target'));
});
gulp.task('package', ['compile'], noop);
gulp.task('server', ['pre-server', 'compile'], function() {
    browserSyncReload();
});
gulp.task('watch', ['server'], function() {
    gulp.watch(src, ['run']);
});
gulp.task('default', ['watch'], noop);
