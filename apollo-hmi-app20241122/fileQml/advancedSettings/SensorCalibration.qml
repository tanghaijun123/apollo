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
    }

    MenuText {
        menuText: "传感器校准"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 10
    }

    Connections{
        target: m_flowsensor
        function onUpdateFlowValue(connState, flowValue) {
            if(advSettings.currentIndex !== 1 && root.visible == true)
            {
                return
            }
            listModel.get(0).value = connState ? "connected" : "disconnected"
            listModel.get(1).value = flowValue
            listModel.get(2).value = ""+m_flowsensor.getBubbleState()
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
                itemName: "流量"
                value: ""
            }
            ListElement {
                itemName: "气泡状态"
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

}
