import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.15
/*! @File        : CustomFooter.qml
 *  @Brief       : 页脚控件
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    id: rtFooter
    width: 1280
    height:80
    color:"#333333"
    property int currentIndex: 0
    property color btnclChecked: "#56B59C"
    property color btnclUnChecked:  "#626262" //"#1F3E38"
    property color cCurSelctBord: "#626262"
    signal clickedBtn(int iIndex)
    ToolBar
    {
        anchors.fill: parent

        background: Rectangle
        {
            anchors.fill:parent
            color:"transparent"
        }
        ButtonGroup{
            id:footerGroup;
            exclusive:true
            onButtonsChanged: {
                Button.text
            }
        }
        RowLayout
        {
            id:buttons
            anchors.fill: parent
            spacing: -2
            ColumnLayout
            {
                id:homeBtnLay
                spacing: -2
                Rectangle
                {
                    id:homeTop
                    width: 60
                    height: 5
                    radius: 4
                    color: "#D2D2D2"
                    visible: false//btnHome.checked
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle
                {
                    id:rectHome
                    width: 316
                    height: 75
                    color: "transparent"
                    radius: 4
                    property bool selected: false
                    Button
                    {
                        id:btnHome
                        ButtonGroup.group: footerGroup
                        anchors.fill: parent
                        focus: true
                        checkable:true
                        checked:true
                        onClicked:{
                            clickedBtn(0);
                            currentIndex = 0;
                            btnHome.checked = true;
                            btnWarningSet.checked = false;
                            btnRecord.checked = false;
                            btnSet.checked = false;
                            rectWarningSet.selected = false;
                            rectRecord.selected = false;
                            rectSet.selected = false;
                            resetSubSelectInfo();
                        }

                        background:Rectangle
                        {
                            implicitWidth:parent.width
                            implicitHeight:parent.height
                            color: btnHome.checked ? btnclChecked:  btnclUnChecked
                            border.color: (/*mainWindow.iSubPageSelectIndex == 0 &&*/ currentIndex ==0) ? mainWindow.rotraySelectRectColor : cCurSelctBord
                            border.width: (/*mainWindow.iSubPageSelectIndex == 0 &&*/ currentIndex ==0) ? mainWindow.rotraySelectBorderWidth : 2
                        }

                        //contentItem:RowLayout
                        //{
                         //   anchors.fill:parent
                            spacing:16
                            Image {
                                id: iconImg
                                width: 32
                                height: 32
                                opacity:btnHome.checked?1:0.8
                                source: "/images/icon_Bottom navigation bar_homepage(Current)@2x.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 108
                                anchors.verticalCenter: parent.verticalCenter
                                ColorOverlay{
                                        anchors.fill: parent
                                        color: btnHome.checked ? "#000000":"#FFFFFF"
                                        source: iconImg
                                    }
                            }
                            Text {
                                id: homeText
                                text: "主页"
                                opacity: btnHome.checked?1:0.6
                                font.family:"OPPOSans"
                                font.weight: Font.Medium
                                font.pixelSize: 26
                                color:btnHome.checked ? "#000000":"#FFFFFF"
                                anchors.left:iconImg.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        //}
                    }
                }
            }         
            CustomLine
            {
                lineHeight:56
                lineWidth:1
                lineColor:"#AAB6C1"
                lineOpacity:0.3
            }
            ColumnLayout
            {
                id:warningLay
                spacing: -2
                Rectangle
                {
                    id:warningTop
                    width: 60
                    height: 5
                    color:"#D2D2D2"
                    radius: 4
                    visible: btnWarningSet.checked
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle
                {
                    id:rectWarningSet
                    width: 316
                    height: 75
                    color: "transparent"
                    radius: 4
                    property bool selected: false
                    Button
                    {
                        id:btnWarningSet
                        ButtonGroup.group: footerGroup
                        anchors.fill: parent
                        checkable:true
                        onClicked:{
                            clickedBtn(1)
                            currentIndex = 1
                            btnHome.checked = false;
                            btnWarningSet.checked = true;
                            btnRecord.checked = false;
                            btnSet.checked = false;
                            rectHome.selected = false;
                            rectRecord.selected = false;
                            rectSet.selected = false;
                            resetSubSelectInfo();
                        }
                        background:Rectangle
                        {
                            implicitWidth:parent.width
                            implicitHeight:parent.height
                            color: btnWarningSet.checked ? btnclChecked:btnclUnChecked
                            border.color: (/*mainWindow.iSubPageSelectIndex == 0 &&*/ currentIndex ==1) ? mainWindow.rotraySelectRectColor : cCurSelctBord
                            border.width: (/*mainWindow.iSubPageSelectIndex == 0 &&*/ currentIndex ==1) ? mainWindow.rotraySelectBorderWidth : 2
                        }

                        //contentItem: RowLayout
                        //{
                            anchors.centerIn:parent
                            spacing:16
                            Image {
                                id: iconWarningImg
                                width: 32
                                height: 32
                                opacity:btnWarningSet.checked?1:0.8
                                source: "/images/icon_Bottom navigation bar_police(current)@2x.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 82
                                anchors.verticalCenter: parent.verticalCenter
                                ColorOverlay{
                                        anchors.fill: parent
                                        color: btnWarningSet.checked ? "#000000":"#FFFFFF"
                                        source: iconWarningImg
                                    }
                            }
                            Text {
                                id: warningText
                                text: "报警设置"
                                opacity: btnWarningSet.checked?1:0.6
                                font.family:"OPPOSans"
                                font.weight: Font.Medium
                                font.pixelSize: 26
                                color:btnWarningSet.checked?"#000000":"#FFFFFF"
                                anchors.left:iconWarningImg.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        //}
                    }
                }
            }
            CustomLine
            {
                lineHeight:56
                lineWidth:1
                lineColor:"#AAB6C1"
                lineOpacity:0.3
            }
            ColumnLayout
            {
                id:recordLay
                spacing: -2
                Rectangle
                {
                    id:recordTop
                    width:60
                    height: 5
                    radius: 4
                    color:"#D2D2D2"
                    visible: btnRecord.checked
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle
                {
                    id:rectRecord
                    width: 316
                    height: 75
                    color: "transparent"
                    radius: 4
                    property bool selected: false
                    Button
                    {
                        id:btnRecord
                        ButtonGroup.group: footerGroup
                        anchors.fill: parent
                        checkable:true
                        onClicked:{
                            clickedBtn(2);
                            currentIndex = 2
                            btnHome.checked = false;
                            btnWarningSet.checked = false;
                            btnRecord.checked = true;
                            btnSet.checked = false;
                            rectHome.selected = false;
                            rectWarningSet.selected = false;
                            rectSet.selected = false;
                            resetSubSelectInfo();
                        }
                        background:Rectangle
                        {
                            implicitWidth:parent.width
                            implicitHeight:parent.height
                            color: btnRecord.checked ? btnclChecked:btnclUnChecked
                            border.color: (/*mainWindow.iSubPageSelectIndex == 0 && */ currentIndex ==2) ? mainWindow.rotraySelectRectColor : cCurSelctBord
                            border.width: (/*mainWindow.iSubPageSelectIndex == 0 && */ currentIndex ==2) ? mainWindow.rotraySelectBorderWidth : 2
                        }

                        //contentItem: RowLayout
                        //{
                        //    anchors.centerIn:parent
                            spacing:16
                            Image {
                                id: iconRecordImg
                                width: 32
                                height: 32
                                opacity:btnRecord.checked?1:0.8
                                source: "/images/icon_Bottom navigation bar_record(current)@2x.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 108
                                anchors.verticalCenter: parent.verticalCenter
                                ColorOverlay
                                {
                                    source: iconRecordImg
                                    color:btnRecord.checked?"#000000":"#FFFFFF"
                                    anchors.fill: parent
                                }
                            }
                            Text {
                                id: recordText
                                text: "记录"
                                opacity: btnRecord.checked?1:0.6
                                font.family:"OPPOSans"
                                font.weight: Font.Medium
                                font.pixelSize: 26
                                color:btnRecord.checked?"#000000":"#FFFFFF"
                                anchors.left:iconRecordImg.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        //}
                    }
                }
            }
            CustomLine
            {
                lineHeight:56
                lineWidth:1
                lineColor:"#AAB6C1"
                lineOpacity:0.3
            }
            ColumnLayout
            {
                id:setLay
                spacing: -2
                Rectangle
                {
                    id:setTop
                    width: 60
                    height: 5
                    color:"#D2D2D2"
                    radius: 4
                    visible: btnSet.checked
                    Layout.alignment: Qt.AlignHCenter
                }
                Rectangle
                {
                    id:rectSet
                    width: 316
                    height: 75
                    color: "transparent"
                    radius: 4
                    property bool selected: false
                    Button
                    {
                        id:btnSet
                        ButtonGroup.group: footerGroup
                        anchors.fill: parent
                        checkable:true
                        onClicked:{
                            clickedBtn(3);
                            currentIndex = 3
                            btnHome.checked = false;
                            btnWarningSet.checked = false;
                            btnRecord.checked = false;
                            btnSet.checked = true;
                            rectHome.selected = false;
                            rectWarningSet.selected = false;
                            rectRecord.selected = false;
                            resetSubSelectInfo();
                            mainWindow.acessPatientPage();
                        }
                        background:Rectangle
                        {
                            implicitWidth:parent.width
                            implicitHeight:parent.height
                            color: rectSet.selected ? Qt.lighter(btnclChecked): (btnSet.checked?btnclChecked:btnclUnChecked)
                            border.color: (/*mainWindow.iSubPageSelectIndex == 0 && */ currentIndex ==3) ? mainWindow.rotraySelectRectColor : cCurSelctBord
                            border.width: (/*mainWindow.iSubPageSelectIndex == 0 &&*/ currentIndex ==3) ? mainWindow.rotraySelectBorderWidth : 2
                        }

                        //contentItem: RowLayout
                      //  {
                            //anchors.fill:parent
                            spacing:16
                            Image {
                                id: iconSetmg
                                width: 32
                                height: 32
                                opacity:btnSet.checked?1:0.8
                                source: "/images/icon_Bottom navigation bar_set up(current)@2x.png"
                                anchors.left: parent.left
                                anchors.leftMargin: 108
                                anchors.verticalCenter: parent.verticalCenter
                                ColorOverlay
                                {
                                    anchors.fill: parent
                                    source: iconSetmg
                                    color:btnSet.checked?"#000000":"#FFFFFF"
                                }
                            }
                            Text {
                                id: setText
                                text: "设置"
                                opacity: btnSet.checked?1:0.6
                                font.family:"OPPOSans"
                                font.weight: Font.Medium
                                font.pixelSize: 26
                                color:btnSet.checked?"#000000":"#FFFFFF"
                                anchors.left:iconSetmg.right
                                anchors.leftMargin: 16
                                anchors.verticalCenter: parent.verticalCenter
                            }
                        //}
                    }
                }

            }
        }
    }

    function resetSubSelectInfo(){
        m_motor.sendMotorSpeed = false;
        mainWindow.bSubComConfirmed = false;
        //mainWindow.iSubPageSelectIndex = 0;
        //mainWindow.bSelInSubPage = false;
        mainWindow.restSelectedPage();
    }
    /*!
    @Function    : setCheckedButton()
    @Description : 设置选中的按钮
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setCheckedButton()
    {
        btnHome.checked = false;
        btnWarningSet.checked = false;
        btnRecord.checked = false;
        btnSet.checked = false;
        if(currentIndex == 0){
            btnHome.checked = true;
        }
        else if(currentIndex == 1){
            btnWarningSet.checked = true;
        }
        else if(currentIndex == 2){
            btnRecord.checked  = true;
        }
        else{
            btnSet.checked = true;
        }

    }
    /*!
    @Function    : setSelected(bSel)
    @Description : 设置选中
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setSelected(bSel){
        rectHome.selected = false;
        rectWarningSet.selected = false;
        rectRecord.selected = false;
        rectSet.selected = false;
        if(currentIndex == 0)
        {
            rectHome.selected = bSel;
        }
        else if(currentIndex == 1)
        {
            rectWarningSet.selected = bSel;
        }
        else if(currentIndex == 2)
        {
            rectRecord.selected = bSel;
        }
        else{
            rectSet.selected = bSel;
        }
    }
    /*!
    @Function    : getSelected()
    @Description : 获取选中
    @Author      : likun
    @Parameter   :
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function getSelected(){
        var bSel = false;
        if(currentIndex == 0)
        {
            bSel = rectHome.selected;
        }
        else if(currentIndex == 1)
        {
            bSel = rectWarningSet.selected;
        }
        else if(currentIndex == 2)
        {
            bSel = rectRecord.selected;
        }
        else{
            bSel = rectSet.selected;
        }
        return {"index":currentIndex,"seleted":bSel};
    }
    Connections{
        target: mainWindow
        function onRotarySelected(step){
            //console.debug("customFooter, onRotarySelected.....", step);
            if(mainWindow.bLocked){
                return;
            }

            if( !mainWindow.bSelInSubPage)
            {
                var tmpIndex = currentIndex;
                //console.debug("onRotarySelected.....tmpIndex:", tmpIndex);

                if (step >0)
                {
                    tmpIndex = (currentIndex+1) % 4
                }
                else
                {
                    tmpIndex = currentIndex - 1;
                    if(tmpIndex < 0)
                    {
                        tmpIndex += 4;
                    }
                }
                //console.debug("customFooter, onRotarySelected.....tmpIndex:", tmpIndex);

                if(tmpIndex == 0){
                    btnHome.clicked();
                }
                else if(tmpIndex == 1){
                    btnWarningSet.clicked()
                }
                else if(tmpIndex == 2){
                    btnRecord.clicked()
                }
                else{
                    btnSet.clicked()
                }

            }
        }
        function onKey_Confirm()
        {
 //           console.debug("customFooter, onKey_Confirm, mainWindow.iSubPageSelectIndex: ", mainWindow.iSubPageSelectIndex);
            if(mainWindow.bLocked){
                return;
            }

//            console.debug("onKey_Confirm..............");
//            if(mainWindow.iSubPageSelectIndex == 0)
//            {
//                var  bcurSelInSubPage = !mainWindow.bSelInSubPage;
//                mainWindow.bSelInSubPage = bcurSelInSubPage;
//                setSelected(bcurSelInSubPage);
//                if(mainWindow.pgCurIndex == 0){  //只做为调速度
//                    m_motor.sendMotorSpeed = bSelInSubPage;
//                    mainWindow.bSubComConfirmed = bSelInSubPage;
//                }
//            }

        }
    }
}
