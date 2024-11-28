import QtQuick 2.5
import QtQuick.Controls 2.4

import "./subcontrol"

Item {
    id: root
    Rectangle {
        color: "#000000"
        anchors.fill: parent
        BackButton {
            id: backBtn
            x: 40
            y: 40

            Connections {
                target: backBtn
                function onClick() {
                    root.visible = false
                    advancedSettingsMenu.visible = true
                }
            }
        }

        MenuText {
            menuText: "电机信息"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }
    }

    Connections{
        target: m_motor
        function onUpdateMotorStatusExtend(connState, errCode, motorSpeed,
                                   boardTemp, motorTemp,
                                   suspenCurrent, torqueCurrent,
                                   postResult, ctrlbFault,
                                   xPos, yPos,
                                   rotorStatus) {
            if(advSettings.currentIndex !== 3 && root.visible == true)
            {
                return
            }
            var strLst
            listModel.get(0).value = connState ? "连接":"断开"
            listModel.get(1).value = errCode.toString()
            listModel.get(2).value = motorSpeed.toString()
            listModel.get(3).value = boardTemp.toString()
            listModel.get(4).value = motorTemp.toString()
            listModel.get(5).value = (suspenCurrent/100.0).toString()
            listModel.get(6).value = (torqueCurrent/100.0).toString()
            strLst = ["自检正常","自检发现故障"]
            listModel.get(7).value = strLst[postResult]
            listModel.get(8).value = ctrlbFault.toString()
            listModel.get(9).value = xPos.toString()
            listModel.get(10).value = yPos.toString()
            strLst = ["静止","悬浮","旋转"]
            listModel.get(11).value = strLst[rotorStatus]
        }
    }

    ListView {
        id:listView;
        anchors.top: parent.top
        anchors.topMargin: 120
        width:parent.width;
        height:parent.height-220;
        clip: true; //超出边界的数据进行裁剪
        delegate:modelItem;
        header:headerView;//只构建表头上滑动时表头也会跟随上滑动消失
        headerPositioning: ListView.InlineHeader;
        boundsBehavior: Flickable.StopAtBounds

        //构建一个Model
        model:ListModel {
            id: listModel
            ListElement {
                itemName: "连接状态"
                value: ""
            }
            ListElement {
                itemName: "错误码"
                value: ""
            }
            ListElement {
                itemName: "电机转速"
                value: ""
            }
            ListElement {
                itemName: "驱动板温度(°C)"
                value: ""
            }
            ListElement {
                itemName: "电机温度(°C)"
                value: ""
            }
            ListElement {
                itemName: "悬浮电流(A)"
                value: ""
            }
            ListElement {
                itemName: "转矩电流(A)"
                value: ""
            }
            ListElement {
                itemName: "自检状态"
                value: ""
            }
            ListElement {
                itemName: "驱动板故障"
                value: ""
            }
            ListElement {
                itemName: "X位移(um)"
                value: ""
            }
            ListElement {
                itemName: "Y位移(um)"
                value: ""
            }
            ListElement {
                itemName: "转子状态"
                value: ""
            }
        }

        Component {
            id:headerView;
            Rectangle {
                width:parent.width;
                height: 40;
                color: "lightgrey";

                Row {
                    width: parent.width;
                    height: parent.height;
                    anchors.left: parent.left;

                    Label {
                        text: "项目";
                        font.pixelSize: 24;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                    Label {
                        text: "值";
                        font.pixelSize: 24;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                }
            }
        }

        Component {
            id:modelItem;
            Rectangle {
                width:parent.width;
                height:40;
                color: "#FFFFFF"
                Row {
                    width:parent.width;
                    anchors.left: parent.left;
                    height:parent.height;

                    Label {
                        text: itemName;
                        font.pixelSize: 20;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                    Label {
                        text: value;
                        font.pixelSize: 20;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                }
            }
        }
    } //ListView


    Rectangle {
        id: row1
        anchors.left: parent.left
        anchors.top: listView.bottom
        anchors.topMargin: 10
        width: parent.width
        height: 40
        Row {
            anchors.fill: parent
            spacing: 10
            Button {
                text: "启动电机";
                font.pixelSize: 20;
                width: 0.1*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    if(mainWindow.bPowerON === false)
                    {
                        m_motor.setMotorStarted(true);
                        m_motor.setSpeedDefault();
                        m_motor.requestCmd("Start")
                        mainWindow.bPowerON = true;
                    }
                }
            }

            Button {
                text: "停止电机";
                font.pixelSize: 20;
                width: 0.1*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    m_motor.setMotorStarted(false);
                    m_motor.setSpeedZero();
                    m_motor.requestCmd("Stop");
                    mainWindow.bPowerON = false;
                }
            }

            Label {
                text: "电机转速设置";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Label {
                id: motorSpeedSetting
                text: "30%";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Slider {
                anchors.verticalCenter: parent.verticalCenter
                from: 1
                to: 5000
                value: 2000
                live: false
                stepSize: 10
                width: 300
                snapMode: Slider.SnapOnRelease
                onValueChanged: {
                    motorSpeedSetting.text = value.toFixed(0)+"%"
                    m_motor.setSpeed(value.toFixed(0));
                }
            }
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.top: row1.bottom
        anchors.topMargin: 10
        width: parent.width
        height: 40
        Row {
            anchors.fill: parent
            spacing: 10
            Button {
                text: "打开限流";
                font.pixelSize: 20;
                width: 0.1*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    m_motor.requestCmdSetMotorCurThredEnabled(true);
                }
            }

            Button {
                text: "关闭限流";
                font.pixelSize: 20;
                width: 0.1*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    m_motor.requestCmdSetMotorCurThredEnabled(false);
                }
            }

            Label {
                text: "限流设置";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Label {
                id: motorCurThred
                text: "3A";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Slider {
                anchors.verticalCenter: parent.verticalCenter
                from: 3
                to: 11
                value: 3
                live: false
                stepSize: 1
                width: 300
                snapMode: Slider.SnapOnRelease
                onValueChanged: {
                    motorCurThred.text = value.toFixed(0)+"A"
                    m_motor.requestCmdSetMotorCurThredValue(value.toFixed(0)*10)
                }
            }
        }
    }
}
