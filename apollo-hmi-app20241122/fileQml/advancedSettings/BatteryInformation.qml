import QtQuick 2.15
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
            menuText: "电池信息"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10
        }
    }

    Connections{
        target: m_power
        function onUpdatePowerStatusExtend(powerOnOff,
                                           bat1chargingState,bat2chargingState,
                                           powerType,
                                           bat1PowerLevel, bat2PowerLevel,
                                           bat1Temp, bat2Temp,
                                           bat1Voltage, bat2Voltage,
                                           bat1Current, bat2Current,
                                           bat1CycleCount,bat2CycleCount,
                                           bat1SN,bat2SN,
                                           bat1RemTime,bat2RemTime,
                                           fanSpeed,postStatus
                                            ){
            if(advSettings.currentIndex !== 2  && root.visible == true)
            {
                return;
            }

            var strList = ["","AC供电","电池1供电","电池2供电"];
            //console.info("=============powerType", powerType)
            listModel.get(0).bat1Value = strList[powerType]

            strList = ["未充电", "充电中", "断开"]
            listModel.get(1).bat1Value = strList[bat1chargingState]
            listModel.get(1).bat2Value = strList[bat2chargingState]

            listModel.get(2).bat1Value = bat1PowerLevel.toString()
            listModel.get(2).bat2Value = bat2PowerLevel.toString()

            listModel.get(3).bat1Value = bat1Temp.toString()
            listModel.get(3).bat2Value = bat2Temp.toString()

            listModel.get(4).bat1Value = bat1Voltage.toString()
            listModel.get(4).bat2Value = bat2Voltage.toString()

            listModel.get(5).bat1Value = bat1Current.toString()
            listModel.get(5).bat2Value = bat2Current.toString()

            listModel.get(6).bat1Value = bat1CycleCount.toString()
            listModel.get(6).bat2Value = bat2CycleCount.toString()

            listModel.get(7).bat1Value = bat1SN.toString()
            listModel.get(7).bat2Value = bat2SN.toString()

            listModel.get(8).bat1Value = bat1RemTime.toString()
            listModel.get(8).bat2Value = bat2RemTime.toString()

            listModel.get(9).bat1Value = fanSpeed.toString()
            listModel.get(10).bat1Value = postStatus.toString()
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
                itemName: "供电方式"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: false
            }
            ListElement {
                itemName: "电池充电状态"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池容量(%)"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池温度(°C)"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池电压(V)"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池电流(A)"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "充电次数"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池序列号"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "电池剩余时间"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: true
            }
            ListElement {
                itemName: "风扇转速"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: false
            }
            ListElement {
                itemName: "开机自检"
                bat1Value: ""
                bat2Value: ""
                bat2Visible: false
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
                        text: "电池1";
                        font.pixelSize: 24;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                    Label {
                        text: "电池2";
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
                        text: bat1Value;
                        font.pixelSize: 20;
                        width: bat2Visible ? 0.2*parent.width : 0.4*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                    }

                    Label {
                        text: bat2Value;
                        font.pixelSize: 20;
                        width: 0.2*parent.width;
                        anchors.verticalCenter: parent.verticalCenter;
                        verticalAlignment: Text.AlignVCenter;
                        horizontalAlignment: Text.AlignHCenter;
                        visible: bat2Visible
                    }
                }
            }
        }
    } //ListView


    Rectangle {
        anchors.left: parent.left
        anchors.bottom: listView.bottom
        anchors.bottomMargin: 10
        width: parent.width
        height: 40
        Row {
            anchors.fill: parent
            spacing: 10
            Label {
                text: "风扇转速设置";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Label {
                id: fanSpeedSetting
                text: "30";
                font.pixelSize: 20;
                width: 0.2*parent.width;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
            }

            Slider {
                anchors.verticalCenter: parent.verticalCenter
                from: 0
                to: 99
                value: 30
                live: false
                stepSize: 1
                snapMode: Slider.SnapOnRelease
                width: 300
                onValueChanged: {
                    fanSpeedSetting.text = value.toFixed(0)
                    m_power.requestUpdateFunSpeedCmd(value.toFixed(0));
                }
            }

            Button {
                text: "打开电机电源";
                font.pixelSize: 20;
                width: 0.15*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    m_power.requestCmd("PowerOnMotor")
                }
            }

            Button {
                text: "关闭电机电源";
                font.pixelSize: 20;
                width: 0.15*parent.width;
                height: 36
                highlighted: true
                anchors.verticalCenter: parent.verticalCenter;
                onReleased: {
                    m_power.requestCmd("PowerOffMotor")
                }
            }
        }
    }
}
