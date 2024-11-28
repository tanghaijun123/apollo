.pragma library


var db
//初始化数据库
function initDatabase() {
    var db = LocalStorage.openDatabaseSync("ApolloDB", "1.0", "Apollo app db");
    try{
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS warnningseting(id INTEGER PRIMARY KEY AUTOINCREMENT, varName TEXT, rangeMin INT, rangeMAX INT)');
        })
    }catch(err){
        console.log("Error creating table in database: " + err);
    }
}

function readParam(varName, defaultMin, defalutMax) {
    var res= false ;
    var rangeMin = defaultMin;
    var rangeMax = defalutMax;
    if(!db) { return {res, rangeMin, rangeMax}; }

    db.transaction( function(tx) {
        var result = tx.executeSql('SELECT rangeMin, rangeMAX FROM warnningseting WHERE varName=?', [varName]);
        if (result.rows.length > 0) {
             res = true;
            rangeMin = result.rows.item(0).value;
            rangeMax = result.rows.item(0).value;
        } else {
            result = tx.executeSql('INSERT INTO warnningseting(varName, rangeMin, rangeMAX) VALUES(?, ?, ?)', [varName, rangeMin, rangeMax]);
        }
    })
    return {res, rangeMin, rangeMax};
}

function insertParam(name, rangeMin, rangeMax) {
    var res = "";
    if(!db) { return; }
    db.transaction( function(tx) {
        var result = tx.executeSql('INSERT OR REPLACE INTO data VALUES (?,?);', [name, value]);
        if (result.rowsAffected > 0) {
          res = "OK";
        } else {
          res = "Error";
        }
    })
    return res
}
