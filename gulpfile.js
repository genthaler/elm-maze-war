var gulp = require('gulp'),
  shell = require('gulp-shell'),
  del = require('del'),
  elm = require('gulp-elm'),
  ghPages = require('gulp-gh-pages'),
  browserSync = require('browser-sync').create(),
  src = ['src/**/*.elm'],
  test = ['src/**/*.elm', 'test/**/*.elm'],
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
gulp.task('reload', ['package'], browserSyncReload);
gulp.task('pre-server', browserSyncInit);
// external tasks
gulp.task('clean', function() {
  return del(['elm-stuff', 'target']);
});
gulp.task('process-resources', [], function() {
  return gulp.src(['./resources/*']).pipe(gulp.dest('target'));
});
gulp.task('compile', ['elm-init'], function() {
  return gulp.src('src/Main.elm').pipe(elm.bundle('elm.js', {
    warn: true
  })).pipe(gulp.dest('target/'));
});
gulp.task('test-compile', ['elm-init'], function() {
  return gulp.src('test/TestRunner.elm').pipe(elm.bundle('TestRunner.js', {
    warn: true
  })).pipe(gulp.dest('target'));
});
gulp.task('test', ['test-compile'], function() {
  return gulp.src('target/TestRunner.js').pipe(shell(
    ['node target/TestRunner.js']))
});
gulp.task('package', ['process-resources', 'compile', 'test'], noop);
gulp.task('server', ['pre-server', 'process-resources', 'compile'], function() {
  browserSyncReload();
});
gulp.task('deploy', function() {
  return gulp.src('./target/**/*').pipe(ghPages());
});
gulp.task('watch', ['test', 'server'], function() {
  gulp.watch(['resources/**/*', 'src/**/*', 'test/**/*'], ['reload']);
});
gulp.task('default', ['watch'], noop);
