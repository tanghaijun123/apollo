import QtQuick 2.0

Rectangle {
    id: backBtn
    property var menuText
    x: 40
    y: 40
    width: 214
    height: 64
    color: enabled ? mouseArea.pressed ? "#11C4A2" : "black": "#404040"
    radius: 4
    signal click()
    Row {
        anchors.fill: parent
        spacing: 0
        Image
        {
            id: backImg
            width: 52
            height: 52
            anchors.verticalCenter: parent.verticalCenter
            fillMode:Image.Stretch
            source: "/images/icon_button_return@2x.png"
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            text: "返回主页"
            color: enabled ? "#FFFFFF" : "#DCDCDC"
            font.weight: Font.Medium
            font.pixelSize: 36
            font.family: "OPPOSans"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: backBtn.enabled
        onClicked: {
            click()
        }
    }
}
