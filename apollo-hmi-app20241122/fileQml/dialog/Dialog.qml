import QtQuick 2.0
import QtQuick.Controls 2.15

Popup {
    id: popup
    width: 200
    height: 150

    contentItem: Rectangle {
        color: "lightblue"
        border.color: "steelblue"
        border.width: 2

        Text {
            text: "这是一个弹窗"
            anchors.centerIn: parent
        }

        Button {
            text: "关闭"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: popup.close()
        }
    }

    // 将弹窗居中显示在父窗口上方
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2 - parent.height / 4

    // 点击外部区域关闭弹窗（如果需要）
    //closePolicy.onPressOutside:
    //    Popup.ClosePolicy.CloseOnPressOutsidePopup

    // 可以根据需要设置弹出和关闭动画效果等属性

}
