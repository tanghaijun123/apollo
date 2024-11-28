import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

/*! @File        : SpeedDataPage.qml
 *  @Brief       : 当前运行页面,转速选中 数据页面
 *  @Author      : likun
 *  @Date        : 2024-08-20
 *  @Version     : v1.0
*/

Rectangle {
    id:rectSpeedDataPage
    width: 230
    height: 304
    color: "transparent"
    ColumnLayout
    {
        id:flowLay
        spacing:20
        anchors.fill: parent
        SpeedMaxSpeed{id:maxSpeedPage;Layout.alignment: Qt.AlignHCenter;curData: maxSpeed}
        SpeedMinSpeed{id:minSpeedPage;Layout.alignment: Qt.AlignHCenter;curData: minSpeed}
        SpeedAverageSpeed{id:avgSpeedPage;Layout.alignment: Qt.AlignHCenter;curData: avgSpeed}
    }
    /*!
    @Function    : setMaxSpeed(text)
    @Description : 设置最大转速
    @Author      : likun
    @Parameter   : text string 最大转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMaxSpeed(text)
    {
        maxSpeedPage.setText(text);
    }
    /*!
    @Function    : setMinSpeed(text)
    @Description : 设置最小转速
    @Author      : likun
    @Parameter   : text string 最小转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setMinSpeed(text)
    {
        minSpeedPage.setText(text);
    }
    /*!
    @Function    : setAvgSpeed(text)
    @Description : 设置平均转速
    @Author      : likun
    @Parameter   : text string 平均转速
    @Return      :
    @Output      :
    @Date        : 2024-08-20
*/
    function setAvgSpeed(text)
    {
        avgSpeedPage.setText(text);
    }
}
