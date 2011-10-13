var Memo, db, exports;
db = Ti.Database.open('db');
db.execute("CREATE TABLE IF NOT EXISTS MEMODB (ID INTEGER PRIMARY KEY, TITLE TEXT, TEXT TEXT, UPDATED TEXT)");
Memo = (function() {
  function Memo(title, text, updated, id) {
    this.title = title;
    this.text = text;
    this.updated = updated != null ? updated : null;
    this.id = id != null ? id : null;
  }
  Memo.prototype.save = function() {
    var date;
    date = (new Date()).getTime();
    if (this.id === null) {
      db.execute("INSERT INTO MEMODB (TITLE, TEXT, UPDATED ) VALUES(?,?,?)", this.title, this.text, date);
      this.id = db.lastInsertRowId;
    } else {
      db.execute("UPDATE MEMODB SET TITLE = ?,TEXT = ?,UPDATED = ? WHERE id = ?", this.title, this.text, date, this.id);
    }
    this.updated = date;
    return this;
  };
  Memo.prototype.del = function() {
    db.execute("DELETE FROM MEMODB WHERE id = ?", this.id);
    return null;
  };
  Memo.prototype.nextMemo = function() {
    var result, rows;
    result = null;
    if (this.updated) {
      rows = db.execute("SELECT * FROM MEMODB WHERE updated > ?", this.updated);
      if (rows.isValidRow()) {
        result = rows.fieldByName('ID');
      }
    }
    return result;
  };
  Memo.prototype.prevMemo = function() {
    var result, rows;
    result = null;
    if (this.updated) {
      rows = db.execute("SELECT ID FROM MEMODB WHERE updated < ?  ORDER BY UPDATED DESC LIMIT 1", this.updated);
    } else {
      rows = db.execute("SELECT ID FROM MEMODB ORDER BY UPDATED DESC LIMIT 1");
    }
    if (rows.isValidRow()) {
      result = rows.fieldByName('ID');
    }
    return result;
  };
  Memo.findById = function(id) {
    var f, memo, rows;
    memo = null;
    rows = db.execute("SELECT * FROM MEMODB WHERE id = ?", id);
    if (rows.isValidRow()) {
      f = rows.fieldByName;
      memo = new Memo(f('TITLE'), f('TEXT'), parseInt(f('UPDATED'), 10), f('ID'));
    }
    rows.close();
    return memo;
  };
  Memo.all = function(limit) {
    var results, rows;
    results = [];
    rows = db.execute("SELECT ID,TITLE,TEXT,UPDATED FROM MEMODB ORDER BY UPDATED DESC LIMIT ?", limit);
    while (rows.isValidRow()) {
      results.push({
        title: rows.fieldByName('TITLE'),
        text: rows.fieldByName('TEXT'),
        updated: parseInt(rows.fieldByName('UPDATED'), 10),
        id: rows.fieldByName('ID')
      });
      rows.next();
    }
    rows.close();
    return results;
  };
  Memo.delAll = function() {
    db.execute("DELETE FROM MEMODB");
  };
  return Memo;
})();
exports = {
  Memo: Memo
};