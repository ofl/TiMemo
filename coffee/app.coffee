#グローバル変数を定義。フォルダの構造と合わせるため変数名をappとする。
app = {}

do ->
  app.helpers = {}
  app.helpers.conf = require 'app/helpers/conf'
  app.helpers.util = require 'app/helpers/util' 
  app.helpers.style = require 'app/helpers/style' 
     
  app.models = require('app/models/Memo')

  app.views = {}
  app.views.root = require('app/views/win')
  app.views.edit = require('app/views/edit/win')
#   app.views = {
#     root: ...
#     edit: ...
#   }
# という風に書けばよさそうだがroot内部からeditを呼び出すためそう書けない。

  app.views.root.win.open()
  
  return
