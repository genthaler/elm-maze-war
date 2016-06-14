var pjson = require('./package.json'),
  ejson = require('./elm-package.json'),
  gulp = require('gulp'),
  gutil = require("gulp-util"),
  shell = require('gulp-shell'),
  del = require('del'),
  elm = require('gulp-elm'),
  expect = require('gulp-expect-file'),
  ghPages = require('gulp-gh-pages'),
  browserSync = require('browser-sync').create(),
  resources = ['resources/**/*', '!resources/ScreenShot.png'],
  src = ['src/**/*.elm'],
  test = ['src/**/*.elm', 'test/**/*.elm'],
  dist = 'dist/' + pjson.version,
  browserSyncInit = function() {
    browserSync.init({
      server: {
        baseDir: dist,
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
  return del(['elm-stuff', 'target', dist]);
});
gulp.task('process-resources', function() {
  return gulp.src(resources).pipe(gulp.dest(dist));
});
gulp.task('validate', function() {
  if (pjson.version != ejson.version) {
    throw new gutil.PluginError({
      plugin: 'validate',
      message: "package.json and elm-package.json versions don't agree"
    });
  }
  return gulp.src(['README.md']).pipe(expect({
    'README.md': 'genthaler.github.io/elm-maze-war/' + pjson.version
  }))
});
gulp.task('compile', ['elm-init'], function() {
  return gulp.src('src/Main.elm').pipe(elm.bundle('elm.js', {
    warn: true
  })).pipe(gulp.dest(dist));
});
gulp.task('test-compile', ['elm-init'], function() {
  return gulp.src('test/TestRunner.elm').pipe(elm.bundle('TestRunner.js', {
    warn: true
  })).pipe(gulp.dest(dist));
});
gulp.task('test', ['test-compile'], function() {
  return gulp.src('target/TestRunner.js ').pipe(shell([
    'node target/TestRunner.js'
  ]))
});
gulp.task('package', ['validate', 'process-resources', 'compile',
  'test-compile'
], noop);
gulp.task('server', ['pre-server', 'process-resources', 'compile'], function() {
  browserSyncReload();
});
gulp.task('deploy', ['package'], function() {
  return gulp.src('./dist/**/*').pipe(ghPages({}));
});
gulp.task('watch', ['test-compile', 'server'], function() {
  gulp.watch(['resources/**/*', 'src/**/*', 'test/**/*'], ['reload']);
});
gulp.task('default', ['watch'], noop);
