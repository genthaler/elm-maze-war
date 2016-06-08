var gulp = require('gulp'),
    shell = require('gulp-shell'),
    del = require('del'),
    elm = require('gulp-elm'),
    browserSync = require('browser-sync')
    .create(),
    src = ['elm/**/*.elm'],
    browserSyncInit = function() {
        browserSync.init({
            server: {
                baseDir: "target",
                index: "index.html"
            },
            port: 4000,
            ui: {
                port: 4001
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
gulp.task('process-resources', [], function() {
    return gulp.src(['./resources/*'])
        .pipe(gulp.dest('target'));
});
gulp.task('compile', ['process-resources', 'elm-init'], function() {
    return gulp.src(src)
        .pipe(elm.bundle('elm.js', {
            warn: true
        }))
        .pipe(gulp.dest('target/'));
});
gulp.task('package', ['compile'], noop);
gulp.task('server', ['pre-server', 'compile'], function() {
    browserSyncReload();
});
gulp.task('watch', ['server'], function() {
    gulp.watch('elm', ['compile-and-reload']);
    gulp.watch('resources', ['process-resources', 'reload']);
});
gulp.task('default', ['watch'], noop);
