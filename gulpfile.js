var gulp = require('gulp'),
  del = require('del'),
  shell = require('gulp-shell'),
  ghPages = require('gulp-gh-pages'),
  browserSync = require('browser-sync').create();
require('gulp-submodule')(gulp);
var main = gulp.submodule('main', {
  filepath: "src/main"
});
var test = gulp.submodule('test', {
  filepath: "src/test"
});
gulp.task('main-clean', shell.task('gulp clean', {
  cwd: 'src/main'
}));
gulp.task('test-clean', shell.task('gulp clean', {
  cwd: 'src/test'
}));
gulp.task('clean', ['main-clean', 'test-clean']);
gulp.task('main-default', shell.task('gulp', {
  cwd: 'src/main'
}))
gulp.task('test-default', shell.task('gulp', {
  cwd: 'src/test'
}));
gulp.task('default', ['main-default', 'test-default'], function() {});
gulp.task('build', shell.task('gulp compile', {
  cwd: 'src/main'
}));
gulp.task('test', shell.task('gulp test', {
  cwd: 'src/test'
}));
gulp.task('deploy', ['build', 'test'], function() {
  return gulp.src('src/main/target/**/*').pipe(ghPages());
});
