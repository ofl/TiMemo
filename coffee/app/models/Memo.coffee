db = Ti.Database.open 'db'
db.execute "CREATE TABLE IF NOT EXISTS MEMODB (ID INTEGER PRIMARY KEY, TITLE TEXT, TEXT TEXT, UPDATED TEXT)"

class Memo
  constructor: (@title, @text, @updated = null, @id = null) ->    
        
  save: () ->
    date = (new Date()).getTime()
    if @id is null
      db.execute "INSERT INTO MEMODB (TITLE, TEXT, UPDATED ) VALUES(?,?,?)", @title, @text, date
      @id = db.lastInsertRowId
    else
      db.execute "UPDATE MEMODB SET TITLE = ?,TEXT = ?,UPDATED = ? WHERE id = ?", @title, @text, date, @id
    @updated = date
    return this
    
  del: () ->
    db.execute "DELETE FROM MEMODB WHERE id = ?", @id
    return null
    
  nextMemo: () ->
    result = null
    if @updated
      rows = db.execute "SELECT * FROM MEMODB WHERE updated > ?", @updated
      if rows.isValidRow()
        result = rows.fieldByName 'ID'        
    return result
            
  prevMemo: () ->
    result = null
    if @updated
      rows = db.execute "SELECT ID FROM MEMODB WHERE updated < ?  ORDER BY UPDATED DESC LIMIT 1", @updated
    else
      rows = db.execute "SELECT ID FROM MEMODB ORDER BY UPDATED DESC LIMIT 1"    
    if rows.isValidRow()
      result = rows.fieldByName 'ID'
    return result
    
  @findById: (id) ->
    memo = null
    rows = db.execute "SELECT * FROM MEMODB WHERE id = ?", id
    
    if rows.isValidRow()
      f = rows.fieldByName
      memo = new Memo f('TITLE'), f('TEXT'), parseInt(f('UPDATED'), 10), f('ID')
    rows.close()
    
    return memo    
            
  @all: (limit) ->
    results = []
    rows = db.execute "SELECT ID,TITLE,TEXT,UPDATED FROM MEMODB ORDER BY UPDATED DESC LIMIT ?", limit
    
    while rows.isValidRow()
      results.push 
        title: rows.fieldByName 'TITLE'
        text: rows.fieldByName 'TEXT'
        updated: parseInt(rows.fieldByName('UPDATED'), 10)
        id: rows.fieldByName 'ID'
      rows.next()
    rows.close()
    
    return results
    
  @delAll: () ->
    db.execute "DELETE FROM MEMODB"
    return
    
exports = 
  Memo: Memo

