var createWindow;
createWindow = function(tab) {
  var $$, Memo, addBtn, doneBtn, dummyImg, dummyImg2, dummyWIn, dummyWIn2, fs, isEditing, mailBtn, memo, mix, nextBtn, nextMemoId, prevBtn, prevMemoId, textArea, trace, transitionMode, trashBtn, updateWindow, window, _createTitle, _neighbors, _transition, _updateMemo;
  Memo = app.models.Memo;
  memo = null;
  mix = app.helpers.util.mix;
  trace = app.helpers.util.trace;
  $$ = app.helpers.style.views.edit;
  isEditing = false;
  transitionMode = null;
  nextMemoId = null;
  prevMemoId = null;
  fs = Ti.UI.createButton($$.fs);
  addBtn = Ti.UI.createButton($$.addBtn);
  doneBtn = Ti.UI.createButton($$.doneBtn);
  mailBtn = Ti.UI.createButton($$.mailBtn);
  nextBtn = Ti.UI.createButton($$.nextBtn);
  prevBtn = Ti.UI.createButton($$.prevBtn);
  trashBtn = Ti.UI.createButton($$.trashBtn);
  window = Ti.UI.createWindow(mix($$.window, {
    title: 'Memo',
    toolbar: [fs, prevBtn, fs, mailBtn, fs, trashBtn, fs, nextBtn, fs]
  }));
  textArea = Ti.UI.createTextArea($$.textArea);
  window.setRightNavButton(addBtn);
  window.add(textArea);
  dummyWIn = Ti.UI.createWindow();
  dummyImg = Ti.UI.createImageView();
  dummyWIn.add(dummyImg);
  dummyWIn2 = Ti.UI.createWindow();
  dummyImg2 = Ti.UI.createImageView();
  dummyWIn2.add(dummyImg2);
  _createTitle = function(text) {
    var line, lines, title, _i, _len;
    lines = textArea.value.split('\n');
    title = '';
    for (_i = 0, _len = lines.length; _i < _len; _i++) {
      line = lines[_i];
      if (line !== '') {
        title = line;
        break;
      }
    }
    return title;
  };
  _updateMemo = function() {
    textArea.blur();
    window.setRightNavButton(addBtn);
    textArea.height = null;
    if (memo.text !== textArea.value) {
      if (!textArea.value) {
        memo.del();
      } else {
        memo.title = _createTitle(textArea.value);
        memo.text = textArea.value;
        memo.save();
        window.title = memo.title;
      }
      Ti.App.fireEvent('root.updateTable');
    }
  };
  updateWindow = function(id) {
    if (id != null) {
      memo = Memo.findById(id);
    } else {
      memo = new Memo('', '');
    }
    textArea.value = memo.text;
    window.title = memo.title !== '' ? memo.title : 'New Memo';
    _neighbors();
  };
  _neighbors = function() {
    nextMemoId = memo.nextMemo();
    prevMemoId = memo.prevMemo();
    nextBtn.enabled = nextMemoId != null ? true : false;
    prevBtn.enabled = prevMemoId != null ? true : false;
  };
  _transition = function() {
    nextBtn.enabled = false;
    prevBtn.enabled = false;
    dummyImg.image = window.toImage();
    dummyWIn.open();
  };
  doneBtn.addEventListener('click', function(e) {
    isEditing = false;
    _updateMemo();
    if (!textArea.value) {
      tab.close(window);
    }
  });
  dummyWIn.addEventListener('open', function(e) {
    switch (transitionMode) {
      case 'new':
        dummyWIn.close({
          transition: Ti.UI.iPhone.AnimationStyle.CURL_UP
        });
        updateWindow();
        break;
      case 'prev':
        updateWindow(prevMemoId);
        dummyImg2.image = window.toImage();
        dummyWIn2.open({
          transition: Ti.UI.iPhone.AnimationStyle.CURL_DOWN
        });
        break;
      case 'next':
        dummyWIn.close({
          transition: Ti.UI.iPhone.AnimationStyle.CURL_UP
        });
        updateWindow(nextMemoId);
    }
  });
  dummyWIn2.addEventListener('open', function(e) {
    switch (transitionMode) {
      case 'prev':
        dummyWIn.close();
        dummyWIn2.close();
    }
  });
  trashBtn.addEventListener('click', function(e) {
    var di;
    di = Ti.UI.createOptionDialog($$.optionDialog);
    di.addEventListener('click', function(e) {
      if (e.index === 0) {
        memo.del();
        Ti.App.fireEvent('root.updateTable');
        if (prevMemoId != null) {
          updateWindow(prevMemoId);
        } else {
          tab.close(window);
        }
      }
    });
    di.show();
  });
  addBtn.addEventListener('click', function(e) {
    transitionMode = 'new';
    _transition();
    setTimeout(textArea.focus, 450);
  });
  prevBtn.addEventListener('click', function(e) {
    transitionMode = 'prev';
    _transition();
  });
  nextBtn.addEventListener('click', function(e) {
    transitionMode = 'next';
    _transition();
  });
  mailBtn.addEventListener('click', function(e) {
    var emailDialog;
    emailDialog = Ti.UI.createEmailDialog({
      subject: memo.title,
      messageBody: memo.text
    });
    emailDialog.open();
  });
  window.addEventListener('close', function(e) {
    if (isEditing) {
      isEditing = false;
      _updateMemo();
    }
  });
  textArea.addEventListener('focus', function(e) {
    isEditing = true;
    window.setRightNavButton(doneBtn);
    trace(Ti.Gesture.orientation);
    if (Ti.Gesture.orientation < 3) {
      textArea.height = 215;
    } else {
      textArea.height = 104;
    }
  });
  window.updateWindow = updateWindow;
  window.focusTextarea = function() {
    return textArea.focus();
  };
  return window;
};
exports.win = {
  open: function(tab, id) {
    var window;
    if (id == null) {
      id = null;
    }
    window = createWindow(tab);
    window.updateWindow(id);
    tab.open(window);
    if (id === null) {
      setTimeout(window.focusTextarea, 400);
    }
  }
};