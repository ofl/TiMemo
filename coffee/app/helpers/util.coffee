exports = 

#デバッグ用及びメモリの使用量を確認 
  trace: (message) ->
    Ti.API.info message
    Ti.API.info "Available memory: " + Ti.Platform.availableMemory
    return

#オブジェクトを結合。例) mix({color:'#000', height:100}, {width:50, top:10})
  mix: () ->
    child = {}
    for arg in arguments
      for prop of arg
        if arg.hasOwnProperty prop
          child[prop] = arg[prop]
    return child

#日付を見やすい形で返す。
  prettyDate: (now) ->
    timeNow = now.getTime()

    cyear = now.getFullYear()
    cmonth = now.getMonth()
    cday = now.getDate()

    deltaToday = parseInt (timeNow - (new Date(cyear, cmonth, cday)).getTime()) / 1000, 10
 
    week = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']

#関数を返す 
   
    (date) ->
      delta = parseInt ((timeNow - date) / 1000), 10
      d = new Date()
      d.setTime(date)
      year = d.getFullYear()
      month = d.getMonth() + 1
      day = d.getDate()
      dayOfWeek = d.getDay()    
      
      result = ''
      if delta < deltaToday
        result = 'Today'
      else if delta < deltaToday + 86400
        result = 'Yesterday'
      else if delta < deltaToday + 518400
        result = week[dayOfWeek]
      else if date < (new Date(cyear, 0, 1)).getTime()
        result = year + '/' +month + '/' + day
      else 
        result = month + '/' + day
  
      return result
