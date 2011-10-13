do ->
  
#   最後に開いていたページ、top、edit、mailとid
  if !Ti.App.Properties.hasProperty('lastPage')
    Ti.App.Properties.setList('lastPage', ['top', 'top'])

exports = {}
