exports.win = (function() {
  var $$, Memo, addBtn, mix, searchBar, tab, tabGroup, table, trace, win, window, _updateTable;
  Memo = app.models.Memo;
  mix = app.helpers.util.mix;
  trace = app.helpers.util.trace;
  $$ = app.helpers.style.views.root;
  window = Ti.UI.createWindow($$.window);
  tab = Ti.UI.createTab({
    window: window
  });
  tabGroup = Ti.UI.createTabGroup();
  addBtn = Ti.UI.createButton($$.addBtn);
  searchBar = Ti.UI.createSearchBar($$.searchBar);
  table = Ti.UI.createTableView(mix($$.tableView, {
    search: searchBar,
    searchHidden: true,
    filterAttribute: 'text'
  }));
  window.setRightNavButton(addBtn);
  window.add(table);
  tabGroup.addTab(tab);
  _updateTable = function() {
    var memo, memos, prettyDate, row, rows, _i, _len;
    memos = Memo.all(1000);
    rows = [];
    prettyDate = app.helpers.util.prettyDate(new Date());
    for (_i = 0, _len = memos.length; _i < _len; _i++) {
      memo = memos[_i];
      row = Ti.UI.createTableViewRow(mix($$.tableViewRow, {
        id: memo.id,
        text: memo.text
      }));
      row.add(Ti.UI.createLabel(mix($$.titleLabel, {
        text: memo.title
      })));
      row.add(Ti.UI.createLabel(mix($$.dateLabel, {
        text: prettyDate(memo.updated)
      })));
      rows.push(row);
    }
    table.setData(rows);
    window.title = 'Memo (' + memos.length + ')';
  };
  window.addEventListener('focus', function(e) {
    table.searchHidden = true;
  });
  addBtn.addEventListener('click', function(e) {
    app.views.edit.win.open(tab);
  });
  table.addEventListener('click', function(e) {
    app.views.edit.win.open(tab, e.row.id);
  });
  table.addEventListener('delete', function(e) {
    var memo;
    memo = Memo.findById(e.row.id);
    memo.del();
  });
  Ti.App.addEventListener('root.updateTable', function() {
    _updateTable();
  });
  win = {
    open: function() {
      _updateTable();
      tabGroup.open();
    }
  };
  return win;
})();