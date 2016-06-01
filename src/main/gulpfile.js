var gulp = require('gulp'),
  shell = require('gulp-shell'),
  del = require('del'),
  elm = require('gulp-elm'),
  browserSync = require('browser-sync').create();
var src = ['elm/**/*.elm'];
gulp.task('clean', function() {
  return del(['elm-stuff']);
});
gulp.task('elm-init', elm.init);
gulp.task('copy', function() {
  return gulp.src(['./resources/*']).pipe(gulp.dest('./dist'));
});
gulp.task('build', ['elm-init'], function() {
  return gulp.src(src).pipe(elm.bundle('elm.js')).pipe(gulp.dest('dist/'));
});
gulp.task('run', function() {
  browserSync.reload()
})
gulp.task('watch', function() {
  gulp.watch(src, ['build'])
});
gulp.task('default', function() {
  browserSync.init({
    server: {
      baseDir: "./dist"
    }
  });
  gulp.run(['copy', 'build', 'run']);
  gulp.watch('elm', ['build', 'run'])
  gulp.watch('resources', ['copy', 'run'])
});
