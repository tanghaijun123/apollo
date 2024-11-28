import QtQuick 2.15
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtCharts 2.15
//import QtGraphicalEffects 1.15

/*! @File        : Alarm.qml
 *  @Brief       : 报警控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Rectangle
{
    required property string textDateContent//alarmTextContent;// "! ! ! 电量过低"//文字框内容
    required property real alarmType //alarmType;//警报类型 0:错误 1:警告
    readonly property string errorAlarmDlgColor: "#E33535";//错误背景色
    readonly property string warningAlarmDlgColor: "#F3D743";//警告背景色
    readonly property string reminderAlarmDlgColor: "#95EC69"; //提示背景色
    readonly property string errorFaceColor: "#FFFFFF"; //错误前景色
    readonly property string warningFaceColor: "#000000"; //警告前景色
    readonly property string errorImgSource:"/images/icon_Status_bar_Alarm(black).png";
    readonly property string warningImgSource: "/images/icon_Status_bar_Alarm.png";
    enum AlarmType
    {
        Error,
        Warning,
        Reminder
    }
    id:alarm
    width:547
    height: 96
    color:(alarmType===Alarm.Error) ? errorAlarmDlgColor : (alarmType===Alarm.Warning) ? warningAlarmDlgColor : reminderAlarmDlgColor
    visible:true
    radius:4
    RowLayout
    {
        id:lay
        anchors.fill: parent
        spacing: 32
        Rectangle
        {
            id:rectImg
            color:"transparent"
            width: 47
            height: 46
            Layout.leftMargin: 80
            Image
            {
                id: img
                anchors.fill: parent
                source: (alarmType===Alarm.Error)?errorImgSource:warningImgSource
            }

        }
        Text
        {
            id: alarm_text
            text:  textDateContent.length>11?textDateContent.slice(0,11)+"\n"+textDateContent.slice(11):textDateContent
            font.bold: true
            color:(alarmType===Alarm.Error)?errorFaceColor:warningFaceColor
            font.family: "OPPOSans"
            font.pixelSize: textDateContent.length>7? 35:40
            font.weight: Font.Bold
        }
    }
    onTextDateContentChanged:
    {
        if(textDateContent.length>11)
            alarm_text.wrapMode=Text.Wrap;
        else
            alarm_text.wrapMode=Text.NoWrap;
    }
}

