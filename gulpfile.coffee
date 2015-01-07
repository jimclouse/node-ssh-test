gulp = require 'gulp'
gutil = require 'gulp-util'
less = require 'gulp-less'
path = require 'path'
minifyCSS = require 'gulp-minify-css'
coffeeify = require 'caching-coffeeify'
uglify = require 'gulp-uglify'
browserify = require 'gulp-browserify'
flatten = require 'gulp-flatten'
exec = require('child_process').exec
concat = require 'gulp-concat'
coffee = require 'gulp-coffee'

isProduction = process.env.NODE_ENV is 'production'

vendorDependencies = ['./bower_components/jquery/dist/jquery.js',
                      './bower_components/bootstrap/dist/js/bootstrap.js',
                      './bower_components/angular/angular.js',
                      './bower_components/angular-route/angular-route.js']

gulp.task 'less', ->
  gulp.src('./public/less/app.less')
    .pipe(less({
      paths: [
        path.join(__dirname,'node_modules')
        path.join(__dirname,'bower_components')
        path.join(__dirname,'public','less')
      ]
    }))
    .on('error', gutil.log)
    .pipe(minifyCSS({
      keepSpecialComments: 0
    }))
    .pipe(gulp.dest('./static/css'))

gulp.task 'wysiLess', ->
  gulp.src('./public/less/wysihtml5-bootstrap3-colors.less')
    .pipe(less())
    .pipe(if isProduction then minifyCSS({keepSpecialComments: 0}) else gutil.noop())
    .pipe(gulp.dest('./static/css'))

gulp.task 'vendor', ->
  gulp.src(vendorDependencies)
    .pipe(concat('vendor.js'))
    .pipe(gulp.dest('./static/js'))

gulp.task 'coffee', ->
  gulp.src(['./public/js/**/*.coffee'])
    .pipe(coffee(bare: true))
    .pipe(concat('app.js'))
    .pipe(gulp.dest('./static/js'))
    .on 'error', gutil.log

gulp.task 'copyImages', ->
  gulp.src('./public/img/**/*.*')
    .pipe(gulp.dest('./static/img'))

gulp.task 'copyFonts', ->
  gulp.src('./bower_components/*/fonts/**/*.*')
    .pipe(flatten())
    .pipe(gulp.dest('./static/fonts'))

  gulp.src('./bower_components/font-awesome/font/*.*')
    .pipe(flatten())
    .pipe(gulp.dest('./static/font'))

gulp.task 'watch', ->
  gulp.watch './public/js/**/*.coffee', ['main.coffee']
  gulp.watch './public/less/*.less', ['less']

gulp.task 'default', [
  'less',
  'wysiLess',
  'vendor',
  'coffee',
  'copyImages',
  'copyFonts'
]