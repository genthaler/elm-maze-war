var gulp = require('gulp'),
	shell = require('gulp-shell'),
	del = require('del'),
	elm = require('gulp-elm'),
	browserSync = require('browser-sync').create();
var src = ['elm/**/*.elm', '../main/elm/**/*.elm'];
gulp.task('clean', function() {
	return del(['elm-stuff']);
});
gulp.task('elm-init', elm.init);
gulp.task('build', ['elm-init'], function() {
	return gulp.src('elm/TestRunner.elm').pipe(elm.make({
		filetype: 'html',
		warn: true
	})).pipe(gulp.dest('dist'));
});
gulp.task('run', function() {
	browserSync.reload()
})
gulp.task('watch', function() {
	gulp.watch(['./gulpfile.js', src], ['build', 'run'])
});
gulp.task('default', function() {
	browserSync.init({
		server: {
			baseDir: "./dist",
			index: "TestRunner.html"
		}
	});
	gulp.run(['build', 'run', 'watch']);
});
