import QtQuick 2.15
import QtQuick.Controls 2.5

/*! @File        : CustomComboBox.qml
 *  @Brief       : 自定义下拉菜单控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    property var  models:[];
    required property string  currentText ;
    property int indicatorWidth: 56
    property int indicatorHeight: 56
    property int currentWidht: 188
    property alias currentIndex:cbCombo.currentIndex
    property real popHeight: 0
    property real contentHeight: 120
    property  int borderWidth: 1//边框宽度
    property string borderColor: "#000000"//整个控件边框
    property string contralColor: "#585858"//整个控件颜色
    property string indicatorColor: "#797979"//下拉框颜色
    property string backgroundColor: "#585858"//背景颜色
    property string indicatorImg: "/images/icon_button_drop-down @2x.png"//下拉框图标
    property  int fontPixelSize: 26//控件当前文字大小
    property int popupHeight: models.length > 5 ? 44*5 : models.length>0?models.length*44:44//弹出框高度
    property string popupBackgroundColor: "#717171"
    /*!
    @Function    : sendIndex(int index)
    @Description : 发送下拉列表项的索引
    @Author      : likun
    @Parameter   : index 项的索引
    @Return      :
    @Date        : 2024-08-14 21:09:45
    */
    signal sendIndex(int index);
    id:rectCB
    width:rectCB.currentWidht
    height:64
    border.color: rectCB.borderColor
    border.width: rectCB.borderWidth
    radius: 4
    color: rectCB.contralColor
//    onCurrentTextChanged: itemText.text=currentText
    ComboBox
    {
        id:cbCombo
        anchors.fill: parent
        model:models
        rightPadding:4
        topPadding:4
        indicator:Rectangle
        {
            width:indicatorWidth  /*56*/
            height:indicatorHeight /*56*/
            x:cbCombo.width-width-cbCombo.rightPadding
            y:cbCombo.topPadding
            color:rectCB.indicatorColor
            Image
            {
               id: cbImg
               anchors.fill: parent
               source: rectCB.indicatorImg
            }
        }
        contentItem: Text
        {     //界面上显示出来的文字
                id:itemText
                leftPadding: 16      //左部填充为5
                text: currentText   //表示ComboBox上显示的文本
                font.family:"OPPOSans"
                font.weight:Font.Normal
                font.pixelSize:rectCB.fontPixelSize
                color: "#FFFFFF"
                verticalAlignment: Text.AlignVCenter        //文字位置
        }
        background: Rectangle {   //背景项
                implicitWidth: 120
                implicitHeight: 40
                color: rectCB.backgroundColor
                border.width: rectCB.borderWidth
                radius: 4
       }

        popup: Popup {    //弹出项
                y: cbCombo.height+5
                width: cbCombo.width
                height: rectCB.popupHeight
//                implicitHeight: cbCombo.popHeight === 0 ? contentItem.implicitHeight : cbCombo.popHeight
                padding: 1

                //istView具有一个模型和一个委托。模型model定义了要显示的数据
                contentItem: ListView
                {   //显示通过ListModel创建的模型中的数据
                    id:listView
                    clip: true
                    implicitHeight: contentHeight
                    model: cbCombo.popup.visible ? cbCombo.delegateModel: null
                    currentIndex:cbCombo.highlightedIndex
                    ScrollIndicator.vertical:ScrollIndicator{}
                }

               background: Rectangle
               {
                    color: rectCB.popupBackgroundColor
                    radius: 4
               }
            }

            delegate: ItemDelegate
            { //呈现标准视图项 以在各种控件和控件中用作委托
                width: cbCombo.width
                height:44
                contentItem: Text
                {
                    text: modelData   //即model中的数据
                    color: "#f6f6f6"
                    //font: cbCombo.font
                    font.family:"OPPOSans"
                    font.weight:Font.Light
                    font.pixelSize:26
                    verticalAlignment: Text.AlignVCenter
                }
                background:Rectangle
                {
                    color:index===cbCombo.highlightedIndex?"#a4a4a4":rectCB.popupBackgroundColor
                    Rectangle
                    {
                        width:parent.width
                        height: 1
                        color:"#8d8d8d"
                    }
                }
                onClicked:
                {
                    rectCB.sendIndex(index)
                }
            }
    }
    /*!
    @Function    : changeListViewIndex( )
    @Description : 更改列表视图索引
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function changeListViewIndex( )
    {
        cbCombo.currentIndex=currentIndex;
    }
}
