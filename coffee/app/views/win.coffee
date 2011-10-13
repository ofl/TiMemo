exports.win = do ->
#   グローバル変数をローカル変数に代入。
  Memo = app.models.Memo
  mix = app.helpers.util.mix
  trace = app.helpers.util.trace
  $$ = app.helpers.style.views.root
  
  window = Ti.UI.createWindow $$.window
        
  tab = Ti.UI.createTab
    window: window
    
  tabGroup = Ti.UI.createTabGroup()
  
  addBtn = Ti.UI.createButton $$.addBtn
  
#    文書を検索するためのsearchBar
  searchBar = Ti.UI.createSearchBar $$.searchBar
    
  table = Ti.UI.createTableView mix $$.tableView,
    search:searchBar
#     searchBarが初期状態では表示されないようにしておく。
    searchHidden:true
    filterAttribute: 'text'
  
  window.setRightNavButton addBtn  
  window.add table  
  tabGroup.addTab tab
    
  _updateTable = () ->
    memos = Memo.all(1000)
    rows = []
#     カリー化
    prettyDate = app.helpers.util.prettyDate new Date()
    for memo in memos
      row = Ti.UI.createTableViewRow mix $$.tableViewRow,
        id: memo.id
        text: memo.text
      row.add Ti.UI.createLabel mix $$.titleLabel,
        text: memo.title      
      row.add Ti.UI.createLabel mix $$.dateLabel,
        text: prettyDate memo.updated
      rows.push row
    table.setData rows
    window.title = 'Memo (' + memos.length + ')'
    return
  
  window.addEventListener 'focus', (e) -> 
#   別のウインドウから戻ると隠れていたsearchBarが表示されてしまうため、
# 　毎回閉じるようにする。（がとても見苦しい。。。）
    table.searchHidden = true
    return
  
  addBtn.addEventListener 'click', (e) -> 
#   addBtnをクリックすると新規作成
    app.views.edit.win.open tab
    return
    
  table.addEventListener 'click', (e) -> 
    app.views.edit.win.open tab, e.row.id
    return
    
  table.addEventListener 'delete', (e) -> 
#   テーブルをスワイプで削除ボタンを表示して、それをクリックした場合。
    memo = Memo.findById e.row.id
    memo.del()
    return
    
  Ti.App.addEventListener 'root.updateTable', () ->
#     編集画面からテーブルをアップデートするためのグローバルイベント。
    _updateTable()
    return
    
  win = 
    open: () ->
      _updateTable()
      tabGroup.open()
      return
  
  return win
 