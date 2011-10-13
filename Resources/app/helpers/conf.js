var exports;
(function() {
  if (!Ti.App.Properties.hasProperty('lastPage')) {
    return Ti.App.Properties.setList('lastPage', ['top', 'top']);
  }
})();
exports = {};