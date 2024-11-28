import QtQuick 2.5
import QtQuick.Controls 2.4

import "./subcontrol"

Rectangle {
    id: root

    color: "#000000"
    anchors.fill: parent
    BackButton {
        id: backBtn
        x: 40
        y: 40

        Connections {
            target: backBtn
            function onClick() {
                if(backBtn.enabled)
                {
                    root.visible = false
                    advancedSettingsMenu.visible = true
                }
            }
        }
    }


    MenuText {
        menuText: "软件升级"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    property var updateMessage: [
        QT_TR_NOOP("Restart UI, please wait for a minutes"),
        QT_TR_NOOP("Error: Can't find firmware.bin"),
    ]

    ProgressCircle {
        id: processCircle
        x: 76
        y: 64
        width: 360
        height: 360
        lineWidth: 36
        anchors.centerIn: parent
        value: 0.0
    }

//    Text {
//        id: version
//        anchors.top: processCircle.top
//        anchors.left: processCircle.right
//        anchors.leftMargin: 70
//        text: qsTr("Current version: ")+translator.tr + page_manager.mainVersion()
//        font: mainTheme.mediumFont
//        color: "#FFFFFFFF"
//    }

    Rectangle {
        id: upgradeButton
        width: 200
        height: 72
        radius: 4
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        color: enabled ? mouseArea.pressed ? "#141515" : "#029074" : "#404040"

        Text {
            id: txt
            text: qsTr("开始升级")
            anchors.centerIn: parent
            color: "#FFFFFF"
            font.weight: Font.Bold
            font.pixelSize: 36
            font.family: "OPPOSans"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            id: mouseArea
            anchors.fill: upgradeButton
            onClicked: {
                startUpdateSoftware()
                //confirmDialog.text = qsTr("The update will restart the application, do you want to continue ?")+translator.tr
                //confirmDialog.open();
                console.info("Start updating software...")

            }
        }
    }

    Timer {
        id: upgradeMsgUpdateTimer
        interval: 200
        running: false
        repeat: true
        onTriggered: {
            processCircle.value = m_upgrade.processPersent();
            var error = m_upgrade.error();
            var flag = m_upgrade.errorFlag();
            console.info("process persent:", processCircle.value, "error:", error, "flag:", flag)
            if(error !== "") {
                closePage.open(pubCode.messageType.Information, "升级错误,请检查升级包", closePage.conMPNone);
                backBtn.enabled = true
                upgradeButton.enabled = true
                upgradeMsgUpdateTimer.running = false
            }
        }
    }

    function startUpdateSoftware()
    {
        if(mainWindow.bPowerON == false)
        {
            /* Start upgrade process */
            var bStart = m_upgrade.startProcess();
            if(bStart) {
                upgradeMsgUpdateTimer.start();
                processCircle.value = 0;
                backBtn.enabled = false
                upgradeButton.enabled = false
                console.info("updating software...")
            } else {
                backBtn.enabled = true
                upgradeButton.enabled = true
                console.info("Start updating failed")
            }
        } else {
            closePage.open(pubCode.messageType.Information, "请到主页停止设备再升级", closePage.conMPNone);
        }
    }

}

