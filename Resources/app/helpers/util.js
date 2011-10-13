var exports;
exports = {
  trace: function(message) {
    Ti.API.info(message);
    Ti.API.info("Available memory: " + Ti.Platform.availableMemory);
  },
  mix: function() {
    var arg, child, prop, _i, _len;
    child = {};
    for (_i = 0, _len = arguments.length; _i < _len; _i++) {
      arg = arguments[_i];
      for (prop in arg) {
        if (arg.hasOwnProperty(prop)) {
          child[prop] = arg[prop];
        }
      }
    }
    return child;
  },
  prettyDate: function(now) {
    var cday, cmonth, cyear, deltaToday, timeNow, week;
    timeNow = now.getTime();
    cyear = now.getFullYear();
    cmonth = now.getMonth();
    cday = now.getDate();
    deltaToday = parseInt((timeNow - (new Date(cyear, cmonth, cday)).getTime()) / 1000, 10);
    week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return function(date) {
      var d, day, dayOfWeek, delta, month, result, year;
      delta = parseInt((timeNow - date) / 1000, 10);
      d = new Date();
      d.setTime(date);
      year = d.getFullYear();
      month = d.getMonth() + 1;
      day = d.getDate();
      dayOfWeek = d.getDay();
      result = '';
      if (delta < deltaToday) {
        result = 'Today';
      } else if (delta < deltaToday + 86400) {
        result = 'Yesterday';
      } else if (delta < deltaToday + 518400) {
        result = week[dayOfWeek];
      } else if (date < (new Date(cyear, 0, 1)).getTime()) {
        result = year + '/' + month + '/' + day;
      } else {
        result = month + '/' + day;
      }
      return result;
    };
  }
};