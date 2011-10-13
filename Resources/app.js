var app;
app = {};
(function() {
  app.helpers = {};
  app.helpers.conf = require('app/helpers/conf');
  app.helpers.util = require('app/helpers/util');
  app.helpers.style = require('app/helpers/style');
  app.models = require('app/models/Memo');
  app.views = {};
  app.views.root = require('app/views/win');
  app.views.edit = require('app/views/edit/win');
  app.views.root.win.open();
})();