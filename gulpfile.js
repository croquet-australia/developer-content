var $ = require('gulp-load-plugins')({ lazy: true });
var gulp = require('gulp');
var shell = require('gulp-shell');

/**
 * List the available gulp tasks
 */
gulp.task('help', $.taskListing);
gulp.task('default', ['help']);

/**
 * Build the Jekyll website
 */
gulp.task('build', function () {
    log('Building Jekyll website...');

    return gulp
        .src('')
        .pipe(shell([
            'echo hello',
            'echo world'
        ]));
});

/**
 * Log a message or series of messages using chalk's blue color.
 * Can pass in a string, object or array.
 */
function log(msg) {
    if (typeof (msg) === 'object') {
        for (var item in msg) {
            if (msg.hasOwnProperty(item)) {
                $.util.log($.util.colors.blue(msg[item]));
            }
        }
    } else {
        $.util.log($.util.colors.blue(msg));
    }
}
