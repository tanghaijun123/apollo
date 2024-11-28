import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
/*! @File        : WarningRecord.qml
 *  @Brief       : 警告记录页面,警告记录数据
 *  @Author      : likun
 *  @Date        : 2024-08-22
 *  @Version     : v1.0
*/

Rectangle
{
    required property int warningType;
//    required property string recordColor;
    required property string textDateContent;
    required property string textTimeContent;
    required property string textRightContent;
//    required property string textColor;
    readonly property string speedWarningBackColor: "#E33535";
    readonly property string flowWarningBackColor: "#F3D743";
    readonly property string commonWarningBackColor: "#95EC69";
    readonly property string removedWarningBackColor: "grey";
    readonly property string otherWarningBackColor : "#F3D743";

    readonly property string speedWarningFontColor: "#FFFFFF";
    readonly property string flowWarningFontColor: "#000000";
    readonly property string commonWarningFontColor: "#000000";
    readonly property string removedWarningFontColor: "#989898";
    readonly property string otherWarningFontColor : "#000000";
    enum WarningType
    {
        SpeedWarning,
        FlowWarning,
        CommonWarning
    }

    id:root
    width:838
    height:44
    color:getBackColor();
    RowLayout
    {
        id:layout
        anchors.fill: parent
        spacing: 0
        Rectangle
        {
            id:rectLeft
            width: 327
            height: root.height
            color:"transparent"
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
            RowLayout
            {
                id:dateTime
                anchors.fill:parent
                spacing: 32
                Rectangle
                {
                    id:rectDate
                    width: 135
                    height: 24
                    color:"transparent"
                    Layout.leftMargin: 32
                    Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
                    Text
                    {
                        id: textDate
                        text: root.textDateContent
                        color:getTextColor(); //root.textColor
                        font.family: "OPPOSans"
                        font.weight: Font.Normal
                        font.pixelSize: 24
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                Rectangle
                {
                    id:rectTime
                    width: 96
                    height: 24
                    color:"transparent"
                    Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
                    Layout.rightMargin: 32
                    Text
                    {
                        id: textTime
                        text: root.textTimeContent
                        color:getTextColor();//root.textColor
                        font.family: "OPPOSans"
                        font.weight: Font.Normal
                        font.pixelSize: 24
                        anchors.fill: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
        Rectangle
        {
            id:line
            width: 1
            height:18
            color:Qt.rgba(255,255,255,0.3)
        }
        Rectangle
        {
            id:rectRight
            width: 510
            height: root.height
            color:"transparent"
            Layout.alignment: Qt.AlignLeft|Qt.AlignVCenter
            Text {
                id: textRight
                text: root.textRightContent
                color:getTextColor();//root.textColor
                font.family: "OPPOSans"
                font.weight: Font.Normal
                font.pixelSize: 24
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                anchors.left: parent.left
                anchors.leftMargin: 68
            }
        }
    }
    /*!
    @Function    : getBackColor()
    @Description : 获取背景颜色
    @Author      : likun
    @Parameter   :
    @Return      : string 颜色代码
    @Output      :
    @Date        : 2024-08-22
*/
    function getBackColor()
    {
        if(warningType/10>=1)
            return removedWarningBackColor;
        if(warningType==WarningRecord.SpeedWarning)
            return speedWarningBackColor;
        if(warningType==WarningRecord.FlowWarning)
            return flowWarningBackColor;
        if(warningType==WarningRecord.CommonWarning)
            return commonWarningBackColor;
        return otherWarningBackColor;
    }
    /*!
    @Function    : getTextColor()
    @Description : 获取文本颜色
    @Author      : likun
    @Parameter   :
    @Return      : string 颜色代码
    @Output      :
    @Date        : 2024-08-22
*/
    function getTextColor()
    {
        if(warningType/10>=1)
            return removedWarningFontColor;
        if(warningType==WarningRecord.SpeedWarning)
            return speedWarningFontColor;
        if(warningType===WarningRecord.FlowWarning)
            return flowWarningFontColor;
        if(warningType===WarningRecord.CommonWarning)
            return commonWarningFontColor;
        return otherWarningFontColor;
    }
}
