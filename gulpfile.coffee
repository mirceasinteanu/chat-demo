gulp 		  = require('gulp')
gutil     = require('gulp-util')
coffee    = require('gulp-coffee')
exec      = require('gulp-exec')
server    = require('gulp-express')
sass      = require('gulp-sass')
rename    = require('gulp-rename')
minifycss = require('gulp-minify-css')

gulp.task 'server', ->
  server.run(['index.js'])

gulp.task 'coffee', ->
  gulp.src('src/coffee/**/*.coffee')
  .pipe(coffee(bare: true).on('error', gutil.log))
  .pipe gulp.dest('')
  return

gulp.task 'watch', ->
  gulp.watch 'src/coffee/*.coffee', [ 'coffee' ]
  gulp.watch 'src/sass/*.sass', [ 'sass' ]
  server.notify
  return

gulp.task 'sass', ->
  gulp.src('src/sass/**/*.sass')
  .pipe(sass(style: 'expanded')).on('error', gutil.log)
  .pipe(minifycss())
  .pipe gulp.dest('style')
  return

gulp.task 'default', [
  'server'
  'sass'
  'coffee'
  'watch'
], ->