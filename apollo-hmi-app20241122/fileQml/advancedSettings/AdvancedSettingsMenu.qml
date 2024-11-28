import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.15
import "./subcontrol"

Item {
    id: root
    width: 1280
    height: 800

    Rectangle {
        id: advancedSettingsMenu
        anchors.fill: parent
        color: "#000000"
        MenuText {
            menuText: "高级设置"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }

        Grid {
            anchors.centerIn: parent
            spacing: 82
            columns: 4
            rows: 1

            Repeater {
                id: repeater
                anchors.fill: parent
                model: ListModel {
                    ListElement { txt: "软件升级" }
                    ListElement { txt: "流量传感器" }
                    ListElement { txt: "电池信息" }
                    ListElement { txt: "电机信息" }
                }

                delegate: Rectangle {
                    width: 248
                    height: 292
                    color: mouseArea.pressed ? "#11C4A2": "#797979"
                    Text {
                        anchors.centerIn: parent
                        text: txt
                        color: "#FFFFFF"
                        font.weight: Font.Bold
                        font.pixelSize: 36
                        font.family: "OPPOSans"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        onClicked: {
                            if(advSettings.currentIndex != index)
                            {
                                advSettings.currentIndex = index
                            } else {
                                advSettings.currentIndex = (index+1)%3
                                advSettings.currentIndex = index
                            }

                            advSettings.visible = true
                            advancedSettingsMenu.visible = false
                        }
                    }
                }
            }
        }
    }

    BackButton {
        id: backBtn
        x: 40
        y: 40

        Connections {
            target: backBtn
            function onClick() {
                advancedSettingsWin.visible = false
                advancedSettingsMenu.visible = true
            }
        }
    }

    StackLayout
    {
        id:advSettings
        anchors.fill: parent
        currentIndex:0
        visible: false
        SoftwareUpdate {
        }
        SensorCalibration {
        }
        BatteryInformation {
        }
        MotorInformation {
        }
    }

}
