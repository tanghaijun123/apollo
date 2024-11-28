import QtQuick 2.15

/*! @File        : CustomBattery.qml
 *  @Brief       : 电池
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/

Rectangle {
    id:root
    property string unuseMAX:"unuseMax";
//    property string UNUSEMORE:"/images/";
//    property string useMAX:"useMax";
//    property string useMORE:"useMore";
//    property string useCHARGING:"useCharging";
    property string currentState: "useMax";

    readonly property string unuseTextColor: "#dcdcdc";
    readonly property string useTextColor: "#f5f5f5";
    readonly property string chargeTextColor: "#FFFFFF";

    readonly property string unUseSource: "/images/status=full_and unused.png";
    readonly property string unConectSource: "/images/status=Not_connected.png";
    readonly property string chargeStateSource: "/images/lightcharge.png";

    readonly property string unuseMaxSource: "/images/status=100%(unused).png";
    readonly property string unuse80Source: "/images/status=80%(unused).png";
    readonly property string unuse60Source: "/images/status=60%(unused).png";
    readonly property string unuse40Source: "/images/status=40%(unused).png";
    readonly property string unuse20Source: "/images/status=20%(unused).png";

    readonly property string useMaxSource: "/images/status=100%.png";
    readonly property string use80Source: "/images/status=80%.png";
    readonly property string use60Source: "/images/status=60%.png";
    readonly property string use40Source: "/images/status=40%.png";
    readonly property string use20Source: "/images/status=20%.png";
    readonly property string use0Source: "/images/status=run_out.png";

    readonly property string chargeMaxSource: "/images/status=100%.png"; //"/images/100%(Charging).png";
    readonly property string charge80Source: "/images/status=80%.png";   //"/images/80%(Charging).png"
    readonly property string charge60Source: "/images/status=60%.png";   //"/images/60%(Charging).png";;
    readonly property string charge40Source: "/images/status=40%.png";   //"/images/40%(Charging).png"
    readonly property string charge20Source: "/images/status=20%.png";   //"/images/20%(Charging).png"
    readonly property string charge0Source: "/images/status=run_out.png";

    /*!
    @Function    : setBarreryState(string statename)
    @Description : 设置电池状态
    @Author      : likun
    @Parameter   : statename string 状态
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    signal setBarreryState(string statename);
    /*!
    @Function    : onSetBarreryState(statename)
    @Description : 设置电池状态
    @Author      : likun
    @Parameter   : statename string 状态
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    Connections
    {
        target: root
        function onSetBarreryState(statename)
        {
            root.currentState=statename;
        }
    }
    width: 48+48+2
    height:48
    color:"transparent"
    Rectangle
    {
        id:barrery
        width: 48
        height: parent.height
        anchors.left: parent.left
        color:"transparent"
        Image {
            id: batteryImg
            source: ""
            anchors.fill: parent
        }
        Text {
            id: textBarreryValue
            text: "100"
            color:"#FFFFFF"
            font.weight: Font.Medium
            font.pixelSize: 12
            font.family: "OPPOSans"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
        }
        state: currentState
        states:[            
            State
            {
                name: "unuseMax"
                PropertyChanges
                {
                    target: batteryImg;
                    source:unUseSource
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:unuseTextColor
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"useMax"
                PropertyChanges {
                    target: batteryImg;
                    source:useMaxSource
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"use80"
                PropertyChanges {
                    target: batteryImg;
                    source:use80Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"use60"
                PropertyChanges {
                    target: batteryImg;
                    source:use60Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"use40"
                PropertyChanges {
                    target: batteryImg;
                    source:use40Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"use20"
                PropertyChanges {
                    target: batteryImg;
                    source:use20Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"use0"
                PropertyChanges {
                    target: batteryImg;
                    source:use0Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"chargingMax"
                PropertyChanges {
                    target: batteryImg;
                    source:chargeMaxSource;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"charging80"
                PropertyChanges {
                    target: batteryImg;
                    source:charge80Source;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"charging60"
                PropertyChanges {
                    target: batteryImg;
                    source:charge60Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"charging40"
                PropertyChanges {
                    target: batteryImg;
                    source:charge40Source;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"charging20"
                PropertyChanges {
                    target: batteryImg;
                    source:charge20Source;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"charging0"
                PropertyChanges {
                    target: batteryImg;
                    source:charge0Source;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:chargeTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:true
                }
            },
            State
            {
                name:"unConnect"
                PropertyChanges {
                    target: batteryImg;
                    source:unConectSource;
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    visible:false
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuseMax"
                PropertyChanges {
                    target: batteryImg;
                    source:unuseMaxSource
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuse80"
                PropertyChanges {
                    target: batteryImg;
                    source:unuse80Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuse60"
                PropertyChanges {
                    target: batteryImg;
                    source: unuse60Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuse40"
                PropertyChanges {
                    target: batteryImg;
                    source: unuse40Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuse20"
                PropertyChanges {
                    target: batteryImg;
                    source: unuse20Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            },
            State
            {
                name:"unuse0"
                PropertyChanges {
                    target: batteryImg;
                    source: unuse0Source
                }
                PropertyChanges
                {
                    target: textBarreryValue;
                    color:useTextColor;
                    visible:true
                }
                PropertyChanges
                {
                    target: rectChargeState;
                    visible:false
                }
            }
        ]
    }
    Rectangle
    {
        id:rectChargeState
        width: 24
        height: 24
        color:"transparent"
        anchors.left: barrery.right
        anchors.leftMargin: -5
        anchors.verticalCenter: root.verticalCenter
        visible: false
        Image {
            id: imgChargeState
            source: chargeStateSource
            anchors.fill: parent
        }
    }
    /*!
    @Function    : setBarreyValue(value)
    @Description : 设置电池值
    @Author      : likun
    @Parameter   : value int  值
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarreyValue(value)
    {
        if(value<0)
            value=0;
        if(value>100)
            value=100;
        textBarreryValue.text=`${value}`;
    }
}
