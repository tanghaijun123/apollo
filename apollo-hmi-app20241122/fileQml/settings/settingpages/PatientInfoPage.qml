import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../subcontral"
//import pollo.CPatientDataOpt 1.0

/*! @File        : PatientInfoPage.qml
 *  @Brief       : 患者信息页面
 *  @Author      : likun
 *  @Date        : 2024-08-16
 *  @Version     : v1.0
*/

Rectangle {
    id:patInfoPage
    //    anchors.fill: parent
    color:"#3D3D3D"
    property bool havValueChanged: false
    property string oldName:"";
    property string realName: "";
    Rectangle
    {
        id:contentRect
        anchors.left: parent.left
        anchors.leftMargin: 56
        anchors.top: parent.top
        anchors.topMargin: 36
        width:1007
        height: 316
        color:"transparent"
//        function move( height ) {
//            contentRect.y += height;
//        }
        ColumnLayout
        {
            id:columnLayout
            spacing: 20
            Rectangle
            {
                id:topRect
                color:"transparent"
                Layout.preferredWidth: contentRect.width
                Layout.preferredHeight: 232
                GridLayout
                {
                    id:topGridLayout
                    rows:3
                    columns: 3
                    rowSpacing: 20
                    columnSpacing: 91
                    PatientNameInput{
                        id:patientNameInput
                        //                        Connections{
                        //                            target:patientNameInput;
                        //                            function ontextContentChanged(){

                        //                            }
                        //                        }

                    }
                    SexSingleSelect{id:sexSingleSelect}
                    AgeInput{
                        id:ageInput

                    }
                    MedicalRecordNumber{
                        id:medicalRecordNumber

                    }
                    BloodType{id:bloodTypeSelect;Layout.columnSpan:2}
                    PatientWeight{
                        id: patientWeight

                    }
                    PatientHeight{
                        id:patientHeight

                    }

                }
            }
            Rectangle
            {
                id:bottomRect
                color:"transparent"
                Layout.preferredWidth: 820
                Layout.preferredHeight: 64
                ImplantDate{id:implanDate}
            }
        }
        //test patient 测试语句,用完删除或者注释掉
        //        Component.onCompleted:
        //        {
        //            var patient={"name":"用完删除或","sex":"男","age":44,"medicalNumber":"abc1234567","bloodType":"AB","weight":85.5,"height":170};
        //            setPatient(patient.name,patient.sex,patient.age,patient.medicalNumber,patient.bloodType,patient.weight,patient.height);

        //            console.log("PatientInfo completed !");
        //        }
    }
    //    property int oldX:0;
    Connections
    {
        target: inputPanel
        function onVisibleChanged()
        {
            //            if(inputPanel.visible)
            //            {
            //                if(medicalRecordNumber.textNumberInput.focus || patientWeight.textWeightInput.focus || patientHeight.textInputHeight.focus )
            //                {
            //                    inputPanel.state="up_visible";
            //                }
            //            }
        }
    }

    Connections
    {
        target: mainWindow
        /*!
    @Function    : onAcessPatientPage()
    @Description : 接收患者信息页面信号
    @Author      : likun
    @Parameter   :
    @Return      :
    @Date        : 2024-08-16
*/
        function onAcessPatientPage()
        {
            var name=patientNameInput.name();
            name=name.replace(/\s*/g,"");
            if(oldName!=""&&oldName==name)
                return;
            if(isNull(name))
                return;
            if(!isString(name))
                return;
            if(name==="")
                return;
            encryptName(name);
        }
    }
    /*!
    @Function    : encryptName(name)
    @Description : 加密姓名
    @Author      : likun
    @Parameter   : name string 姓名
    @Return      :
    @Date        : 2024-08-16 22:38:35
*/
    function encryptName(name)
    {
        if(name.length==2)
        {
            patientNameInput.setName(`${name[0]}*`);
            oldName=`${name[0]}*`;
            realName=name;
            return ;
        }
        if(name.length>2)
        {
            patientNameInput.setName(`${name[0]}*${name[name.length-1]}`);
            oldName=`${name[0]}*${name[name.length-1]}`;
            realName=name;
            return;
        }
    }
    /*!
    @Function    : isNumber(value)
    @Description : 判断是否为数字
    @Author      : likun
    @Parameter   : value string 值
    @Return      : true 数字 false 非数字
    @Date        : 2024-08-16
*/

    function isNumber(value)
    {
        return typeof(value)=="number";
    }
    /*!
    @Function    : isString(value)
    @Description : 判断是否为字符串
    @Author      : likun
    @Parameter   : value var 值
    @Return      : true 是字符串  false 不是字符串
    @Date        : 2024-08-16
*/
    function isString(value)
    {
        return typeof(value)=="string";
    }
    /*!
    @Function    : isNull(value)
    @Description : 判断是否为null
    @Author      : likun
    @Parameter   : value var 值
    @Return      : true 是null false 不是null
    @Date        : 2024-08-16
*/
    function isNull(value)
    {
        if(value===undefined || value===null)
            return true;
        return false;
    }

//    function checkName(name)
//    {
//        if(isNull(name))
//            return false;
//        if(!isString(name))
//            return false;
//        if(name.length<2||name.length>10)
//            return false;
//        return true;
//    }

//    function checkSex(sex)
//    {
//        if(isNull(sex))
//            return false;
//        if(!isString(sex))
//            return false
//        if(sex!=="男"&&sex!=="女")
//            return false;
//        return true;
//    }

//    function checkAge(age)
//    {
//        if(isNull(age))
//            return false;
//        if(!isNumber(age))
//            return false;
//        if(age<0||age>150)
//            return false;
//        return true;
//    }

//    function checkMedicalNumber(medicalNumber)
//    {
//        if(isNull(medicalNumber))
//            return false;
//        if(!isString(medicalNumber))
//            return false;
//        if(medicalNumber.length<1||medicalNumber.length>10)
//            return false;
//        return true;
//    }

//    function checkBloodType(bloodType)
//    {
//        if(isNull(bloodType))
//            return false;
//        if(!isString(bloodType))
//            return false;
//        var bloodTypes=["AB","A","B","O","RH"];
//        if(!bloodType in bloodTypes )
//            return false;
//        return true;
//    }

//    function checkWeight(weight)
//    {
//        if(isNull(weight))
//            return false;
//        if(!isNumber(weight))
//            return false;
//        if(weight < 0 || weight > 999)
//            return false;
//        return true;
//    }

//    function checkHeight(height)
//    {
//        if(isNull(height))
//            return false;
//        if(!isNumber(height))
//            return false;
//        if(height<0 || height>999)
//            return false;
//        return true;
//    }

    /*!
    @Function    : setPatient(name,sex,age,medicalNumber,bloodType,weight,height, curimplanDate)
    @Description : 设置患者信息
    @Author      : likun
    @Parameter   : name 姓名,sex 性别,age 年龄,medicalNumber 病历号,bloodType 血型,weight 体重,height 身高, curimplanDate 日期字符串
    @Return      :
    @Date        : 2024-08-16
*/
    function setPatient(name,sex,age,medicalNumber,bloodType,weight,height, curimplanDate)
    {
        //patientNameInput.setName(name);
        encryptName(name);
        ageInput.setAge(age);
        sexSingleSelect.setSex(sex);
        medicalRecordNumber.setMedicalNumber(medicalNumber);
        bloodTypeSelect.setBloodType(bloodType);
        patientWeight.setWeight(weight);
        console.debug("setPaitent-",curimplanDate);
        patientHeight.setHeight(height);
        implanDate.setDateTime(new Date(curimplanDate)/*Date.fromLocaleString(Qt.locale(), curimplanDate, "yyyy-MM-dd hh:mm:ss")*/);

    }

    /*!
    @Function    : getPatient()
    @Description : 获取患者信息
    @Author      : likun
    @Parameter   :
    @Return      : {name:string,sex:string,age:int,medicalNumber:string,bloodType:string,weight:float,height:float,year:int,month:int,day:int}
    @Date        : 2024-08-16 22:57:49
*/
    function getPatient()
    {
        var patient={};
        patient.name=realName;
        patient.sex=sexSingleSelect.sex();
        patient.age=ageInput.age();
        patient.medicalNumber=medicalRecordNumber.medicalNumber();
        patient.bloodType=bloodTypeSelect.bloodType();
        patient.weight=patientWeight.weight();
        patient.height=patientHeight.height();
        var curDate=implanDate.getDate();
        patient["year"]=curDate.year;
        patient["month"]=curDate.month;
        patient["day"]=curDate.day;
        return patient;
    }
//    CPatientDataOpt{
//        id: dbPatient
//    }
    property bool bCanProcessAutoSave: false;
    Timer{
        id: tmrStartProcessAutoSave
        interval: 3 * 1000
        repeat: false;
        running:  false;
        onTriggered: {
            bCanProcessAutoSave = true;
            var vRes = dbPatient.getPatientInfo();
            if(vRes.res === 0){
                setPatient(vRes.PatientName, vRes.PatientSex, vRes.PatientAge, vRes.PatientID, vRes.BloodType,
                           vRes.Weight, vRes.Height, vRes.ImplantationTime);
            }
            else{
                console.debug("getPatientInfo false, return ", vres);
            }
            tmrDelayupdatePatientParam.running = false;
        }
    }

    Timer{
        id: tmrDelayupdatePatientParam
        interval: /*5 * 1000*/500
        repeat: false;
        running:  false;
        onTriggered: {
            if(bCanProcessAutoSave == false){
                return;
            }
            var vres = dbPatient.setPatientInfo(realName/*patientNameInput.name()*/, sexSingleSelect.sex(), ageInput.age(), medicalRecordNumber.medicalNumber(),bloodTypeSelect.bloodType(), patientWeight.weight(), patientHeight.height(),Qt.formatDate(implanDate.getDateTime(),"yyyy-MM-dd"/*"yyyy-MM-dd hh:mm:ss"*/));
            if(vres !==0){
                console.debug("setPatientInfo false, return ", vres);
            }
        }
    }
    Connections
    {
        target: closePage
        function onSendClose()
        {
            encryptName(patientNameInput.name());
            var vres = dbPatient.setPatientInfo(realName/*patientNameInput.name()*/, sexSingleSelect.sex(), ageInput.age(), medicalRecordNumber.medicalNumber(),
                                                bloodTypeSelect.bloodType(), patientWeight.weight(), patientHeight.height(),
                                                Qt.formatDate(implanDate.getDateTime(),"yyyy-MM-dd"/*"yyyy-MM-dd hh:mm:ss"*/));
            if(vres !==0){
                console.debug("setPatientInfo false, return ", vres);
            }
        }
    }

    Connections{
        target: mainWindow
        function onHavePatientValueChanged(){
            tmrDelayupdatePatientParam.restart()
        }
    }
    Component.onCompleted: {
        tmrStartProcessAutoSave.running = true;
    }

}
