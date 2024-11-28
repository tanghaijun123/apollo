import QtQuick 2.0

Text {
    property var menuText
    text: menuText
    color: enabled ? "#FFFFFF" : "#DCDCDC"
    font.weight: Font.Medium
    font.pixelSize: 40
    font.family: "OPPOSans"
}

