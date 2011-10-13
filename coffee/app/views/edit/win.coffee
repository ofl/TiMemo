#編集画面。残念ながらTitaniumのテキストエリアは内部のテキストのpaddingが設定できないようです。
#あと背景にイメージも設定できないため残念なできとなっています。

createWindow = (tab) ->
#グローバル変数をローカル変数に代入。
  Memo = app.models.Memo
  memo = null
  mix = app.helpers.util.mix
  trace = app.helpers.util.trace
  $$ = app.helpers.style.views.edit

#編集中かどうか(BOOL)
  isEditing = false

#トランジションのタイプ(new/prev/next)  
  transitionMode = null
  
#前後のmemoのid  
  nextMemoId = null
  prevMemoId = null
  
  fs = Ti.UI.createButton $$.fs
  addBtn = Ti.UI.createButton $$.addBtn
  doneBtn = Ti.UI.createButton $$.doneBtn
  mailBtn = Ti.UI.createButton $$.mailBtn
  nextBtn = Ti.UI.createButton $$.nextBtn
  prevBtn = Ti.UI.createButton $$.prevBtn
  trashBtn = Ti.UI.createButton $$.trashBtn
        
  window = Ti.UI.createWindow mix $$.window,
    title: 'Memo'
    toolbar: [fs, prevBtn, fs, mailBtn, fs, trashBtn, fs, nextBtn, fs]
  
  textArea = Ti.UI.createTextArea $$.textArea
        
  window.setRightNavButton addBtn  
  window.add textArea
  
#トランジションのためのダミーのウインドウとimageView 
  dummyWIn = Ti.UI.createWindow()
  dummyImg = Ti.UI.createImageView()
  dummyWIn.add dummyImg
  dummyWIn2 = Ti.UI.createWindow()
  dummyImg2 = Ti.UI.createImageView()
  dummyWIn2.add dummyImg2

#タイトルは最初に文字のある列。
  _createTitle = (text)->
    lines = textArea.value.split '\n'
    title = ''
    for line in lines
      if line isnt ''
        title = line
        break
    return title

#メモを更新 
  _updateMemo = ()->
    textArea.blur()
    window.setRightNavButton addBtn
#テキストエリアの高さをリセット
    textArea.height = null
#テキストエリアの内容が更新されていたらメモデータを更新
    if memo.text isnt textArea.value
# テキストがなければ削除
      if !textArea.value
        memo.del()
      else
# メモを更新
        memo.title = _createTitle textArea.value
        memo.text = textArea.value
        memo.save()
        window.title = memo.title
      Ti.App.fireEvent 'root.updateTable'
    return

#タイトルとテキストエリアの内容を更新 
  updateWindow = (id)->
    if id?
      memo = Memo.findById id
    else
#新規作成時
      memo = new Memo('', '')    
    textArea.value = memo.text
    window.title = if memo.title isnt '' then memo.title else 'New Memo'
    _neighbors()
    return

#前後にメモがあるかどうか。       
  _neighbors = ()->
    nextMemoId = memo.nextMemo()
    prevMemoId = memo.prevMemo()
    nextBtn.enabled = if nextMemoId? then true else false
    prevBtn.enabled = if prevMemoId? then true else false
    return

#トランジションのアクション      
  _transition = ()->
    nextBtn.enabled = false
    prevBtn.enabled = false
    dummyImg.image = window.toImage()
    dummyWIn.open()
    return
    
#編集完了
  doneBtn.addEventListener 'click', (e) -> 
    isEditing = false
    _updateMemo()
#テキストがなければウインドウを閉じる
    if !textArea.value
      tab.close window
    return

#トランジション    
  dummyWIn.addEventListener 'open', (e) -> 
    switch transitionMode
      when 'new' 
        dummyWIn.close({transition:Ti.UI.iPhone.AnimationStyle.CURL_UP})
        updateWindow()
      when 'prev' 
        updateWindow prevMemoId
        dummyImg2.image = window.toImage()
        dummyWIn2.open({transition:Ti.UI.iPhone.AnimationStyle.CURL_DOWN})
      when 'next' 
        dummyWIn.close({transition:Ti.UI.iPhone.AnimationStyle.CURL_UP})
        updateWindow nextMemoId
    return

#トランジション    
  dummyWIn2.addEventListener 'open', (e) -> 
    switch transitionMode
      when 'prev' 
        dummyWIn.close()
        dummyWIn2.close()
    return

#ゴミ箱ボタンを押した時
#本来アニメーションしたいところだが面倒なので実装見送り
  trashBtn.addEventListener 'click', (e) -> 
#確認のためのダイアログを表示
    di = Ti.UI.createOptionDialog $$.optionDialog
    di.addEventListener 'click', (e)->
      if e.index is 0
        memo.del()
#リストを更新しておく
        Ti.App.fireEvent 'root.updateTable'
        if prevMemoId?
          updateWindow prevMemoId
        else
          tab.close window
      return
    di.show()
    return

  addBtn.addEventListener 'click', (e) -> 
    transitionMode = 'new'
    _transition()
    setTimeout textArea.focus, 450
    return

  prevBtn.addEventListener 'click', (e) -> 
    transitionMode = 'prev'
    _transition()
    return

  nextBtn.addEventListener 'click', (e) -> 
    transitionMode = 'next'
    _transition()
    return

#メール作成ダイアログを表示
  mailBtn.addEventListener 'click', (e) -> 
    emailDialog = Ti.UI.createEmailDialog
      subject: memo.title
      messageBody: memo.text
    emailDialog.open()
    return
          
  window.addEventListener 'close', (e) -> 
    if isEditing
      isEditing = false
      _updateMemo()
    return
          
  textArea.addEventListener 'focus', (e) -> 
    isEditing = true
    window.setRightNavButton doneBtn
#キーボードの表示にあわせテキストエリアの高さを変更する
    trace Ti.Gesture.orientation
    
    if Ti.Gesture.orientation < 3
#縦表示時
      textArea.height = 215
    else
#横表示時
      textArea.height = 104
    return

#外部に公開したい関数をwindowオブジェクトに紐付け。
  window.updateWindow = updateWindow
  window.focusTextarea = ()->
    textArea.focus()
  
  return window
          
exports.win = 
#idがない場合（新規作成時）デフォルトはnullとする
  open: (tab, id = null) ->

#引数にtabを渡してウインドウを作成
    window = createWindow tab

#表示状態を更新     
    window.updateWindow id
    
    tab.open window
    
#新規作成時にはキーボードを開く
    if id is null
      setTimeout window.focusTextarea, 400
    return
