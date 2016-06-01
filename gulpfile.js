var gulp = require('gulp'),
  shell = require('gulp-shell'),
  del = require('del'),
  elm = require('gulp-elm'),
  browserSync = require('browser-sync').create();
require('gulp-submodule')(gulp);
var main = gulp.submodule('main', {
  filepath: "src/main"
});
var test = gulp.submodule('test', {
  filepath: "src/test"
});
gulp.task('clean', ['main:clean', 'test:clean', ], function() {
  console.log('Cleaning...');
});
gulp.task('build', ['main:build', 'test:build'], function() {
  console.log('Building...');
});
gulp.task('watch', ['main:watch', 'test:watch', ], function() {
  console.log('Watching...');
});
gulp.task('run-tests', ['build', 'build-tests', 'test:run-tests'], function() {
  browserSync.reload()
})
gulp.task('default', function() {
  browserSync.init({
    server: {
      baseDir: "./dist/test"
    }
  });
  gulp.run('run-tests');
  gulp.watch(['src/main/elm/**/*.elm', 'src/test/elm/**/*.elm', ], [
    'run-tests'
  ])
});
