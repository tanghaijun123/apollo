//.pragma library

var db

//初始化数据库
function initDatabase() {
    var res = false;
    db = LocalStorage.openDatabaseSync("ApolloSettingDB", "1.0", "Apollo settings db", 10000);
    if(!db) { return res;}

    try{
        db.transaction(function(tx){
            tx.executeSql('CREATE TABLE IF NOT EXISTS warnningseting(id INTEGER PRIMARY KEY AUTOINCREMENT, varName TEXT, rangeMin REAL, rangeMax REAL)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS appParams(id INTEGER PRIMARY KEY AUTOINCREMENT, paramName TEXT, paramTitile TEXT, paramValue TEXT)');
            res = true;
        }
        )
    }catch(err){
        console.log("Error creating table in database: " + err);
    }
    return res;
}
////////////////////////参数读写部分//////////////////////////////////////////////////////
//读参数内部接口
function _getParam(varName, defaultMin, defalutMax){

    if(!db) { return {"res":false,"rangeMin":defaultMin,"rangeMax":defalutMax}; }
    var res = {"res":false,"rangeMin":defaultMin,"rangeMax":defalutMax};
    db.transaction( function(tx) {
        var result = tx.executeSql('SELECT rangeMin, rangeMax FROM warnningseting WHERE varName=?', [varName]);

        if (result.rows.length > 0) {
            res = {"res":true,"rangeMin":result.rows.item(0).rangeMin,"rangeMax":result.rows.item(0).rangeMax};
        }


    })
    return res;
}

//插入参数内部接口
function _insertParam(varName, rangeMin, rangeMax){
    var res= false ;    
    if(!db) { return res; }

    db.transaction( function(tx) {
        var result = tx.executeSql('INSERT INTO warnningseting(varName, rangeMin, rangeMAX) VALUES(?,?,?)', [varName, rangeMin, rangeMax]);
        if (result.rowsAffected > 0) {
             res = true;
        }
    })
    return res;
}

//更新参数内部接口
function _updateParam(varName, rangeMin, rangeMax){
    var res= false;
    if(!db) { return res; }

    db.transaction( function(tx) {
        var result = tx.executeSql('UPDATE warnningseting SET rangeMin=?, rangeMAX=? WHERE varName=?', [rangeMin, rangeMax, varName]);
        if (result.rowsAffected > 0) {
             res = true;
        }
    })
    return res;
}

//获取参数接口
function getParam(varName, defaultMin, defalutMax) {
    var result = _getParam(varName, defaultMin, defalutMax);
    if( result.res === true)
    {
        return result;
    }

    var res = _insertParam(varName, defaultMin, defalutMax);
    return {"res":res,"rangeMin":defaultMin,"rangeMax":defalutMax};
}

//更新新参数接口
function setParam(varName, rangeMin, rangeMax) {
    var res = false;
    var result = _getParam(varName, rangeMin, rangeMax);
    if(result.res === true){
        res = _updateParam(varName, rangeMin, rangeMax);
        return res;
    }
    res = _insertParam(varName, rangeMin, rangeMax);
    return res;
}
//////////////////////////////////////////////////////////////////////////////

/////////////////////////系统参数及设备信息设置//////////////////////////////////////////////
//读参数内部接口
function _getSysParam(paramName){

    var res = {"res":false,"ParamValue":""};
    if(!db) { return res; }

    db.transaction( function(tx) {
        var result = tx.executeSql('SELECT paramValue FROM appParams WHERE paramName=?', [paramName]);

        if (result.rows.length > 0) {
            res = {"res":true,"paramValue":result.rows.item(0).paramValue};
        }
    })
    return res;
}

//插入参数内部接口
function _insertSysParam(paramName, paramTitile, paramValue){
    var res= false ;
    if(!db) { return res; }

    db.transaction( function(tx) {
        var result = tx.executeSql('INSERT INTO appParams(paramName, paramTitile, paramValue) VALUES(?,?,?)', [paramName, paramTitile, paramValue]);
        if (result.rowsAffected > 0) {
             res = true;
        }
    })
    return res;
}

//更新参数内部接口
function _updateSysParam(paramName, paramValue){
    var res= false ;
    if(!db) { return res; }

    db.transaction( function(tx) {
        var result = tx.executeSql('UPDATE appParams SET paramValue=? WHERE paramName=?', [rangeMin, rangeMax, varName]);
        if (result.rowsAffected > 0) {
             res = true;
        }
    })
    return res;
}

//获取参数接口
function getSysParam(paramName, defaultParamValue, defaultParamTitile = "") {
    var result = _getSysParam(paramName);
    if( result.res === true)
    {
        return result;
    }

    var res = _insertSysParam(paramName, defaultParamTitile, defaultParamValue);
    return {"res":res,"paramValue":paramValue};
}

//更新新参数接口
function setSysParam(paramName, paramValue, paramTitile = "") {
    var res = false;
    var result = _getSysParam(paramName);
    if(result.res === true){
        res = _updateSysParam(paramName, paramValue);
        return res;
    }
    res = _insertSysParam(paramName, paramTitile, paramValue);
    return res;
}
//////////////////////////////////////////////////////////////////////////////





