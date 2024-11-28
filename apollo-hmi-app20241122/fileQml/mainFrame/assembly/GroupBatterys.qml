import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

/*! @File        : GroupBatterys.qml
 *  @Brief       : 电池组
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Rectangle {
    enum PowerType//powerType
    {
        Acpower=1,
        Battery1=2,
        Battery2=3
    }
    enum ChargingState
    {
        Idle=0,
        Charging=1,
        UnConnect=2
    }

    id:root
    width:48
    height:96
    color:"transparent"
    signal barreryStateChange(int powerOnOff,
                              int bat1ChargingState,
                              int bat2ChargingState,
                              int powerType,
                              int bat1PowerLevel,
                              int bat2PowerLevel);

    CustomBattery
    {
        id:one
        //height: parent.height /3
        anchors.top: parent.top
        anchors.topMargin: 8
    }
    CustomBattery
    {
        id:two
        //height: parent.height /3
        anchors.top: one.bottom
        anchors.topMargin: -10
    }
    Connections
    {
        target: root
        function onBarreryStateChange(powerOnOff,
                                      bat1ChargingState,
                                      bat2ChargingState,
                                      powerType,
                                      bat1PowerLevel,
                                      bat2PowerLevel)
        {

            if(isNaN(powerType) || !isFinite(powerType))
            {
                console.log("powerType is not number! powerType=",powerType);
                return;
            }
            if(isNaN(bat1ChargingState) || !isFinite(bat1ChargingState))
            {
                console.log("bat1ChargingState is not number! chargingState=",bat1ChargingState);
                return;
            }
            if(isNaN(bat2ChargingState) || !isFinite(bat2ChargingState))
            {
                console.log("bat2ChargingState is not number! chargingState=",bat2ChargingState);
                return;
            }
            if(isNaN(bat1PowerLevel) || !isFinite(bat1PowerLevel))
            {
                console.log("bat1PowerLevel is not number! bat1PowerLevel=",bat1PowerLevel);
                return;
            }
            if(isNaN(bat2PowerLevel) || !isFinite(bat2PowerLevel))
            {
                console.log("bat2PowerLevel is not number! bat2PowerLevel=",bat2PowerLevel);
                return;
            }

            if(powerType===GroupBatterys.PowerType.Acpower)
            {
                if(bat1ChargingState===GroupBatterys.ChargingState.Idle)
                {
                    setBarrery1UnUseType(bat1PowerLevel)
                }
                else if(bat1ChargingState===GroupBatterys.ChargingState.Charging)
                {
                    setBarrery1ChargingType(bat1PowerLevel);
                }
                else if(bat1ChargingState===GroupBatterys.ChargingState.UnConnect)
                {
                    one.setBarreryState("unConnect");
                }

                if(bat2ChargingState===GroupBatterys.ChargingState.Idle)
                {
                    setBarrery2UnUseType(bat2PowerLevel)
                }
                else if(bat2ChargingState===GroupBatterys.ChargingState.Charging)
                {
                    setBarrery2ChargingType(bat2PowerLevel);
                }
                else if(bat2ChargingState===GroupBatterys.ChargingState.UnConnect)
                {
                    two.setBarreryState("unConnect");
                }
            }
            else if(powerType===GroupBatterys.PowerType.Battery1)
            {
                setBarrery1UseType(bat1PowerLevel);
                if(bat2ChargingState===GroupBatterys.ChargingState.Idle)
                {
                    setBarrery2UnUseType(bat2PowerLevel)
                }
                else if(bat2ChargingState===GroupBatterys.ChargingState.Charging)
                {
                    setBarrery2ChargingType(bat2PowerLevel);
                }
                else if(bat2ChargingState===GroupBatterys.ChargingState.UnConnect)
                {
                    two.setBarreryState("unConnect");
                }
            }
            else if(powerType===GroupBatterys.PowerType.Battery2)
            {
                setBarrery2UseType(bat2PowerLevel);
                if(bat1ChargingState===GroupBatterys.ChargingState.Idle)
                {
                    setBarrery1UnUseType(bat1PowerLevel)
                }
                else if(bat1ChargingState===GroupBatterys.ChargingState.Charging)
                {
                    setBarrery1ChargingType(bat1PowerLevel);
                }
                else if(bat1ChargingState===GroupBatterys.ChargingState.UnConnect)
                {
                    one.setBarreryState("unConnect");
                }
            }
        }
    }

    Component.onCompleted:
    {
        one.setBarreryState(one.unuseMAX);
        one.setBarreyValue(100);
        two.setBarreryState(two.unuseMAX);
        two.setBarreyValue(100);
    }
    /*!
    @Function    : setBarrery2UseType(bat2PowerLevel)
    @Description : 设置电池2使用类型
    @Author      : likun
    @Parameter   : bat2PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery2UseType(bat2PowerLevel)
    {
        two.setBarreyValue(bat2PowerLevel);
        if(bat2PowerLevel>=0&&bat2PowerLevel<20)
        {
            two.setBarreryState("use0");
        }else if(bat2PowerLevel>=20&&bat2PowerLevel<40)
        {
            two.setBarreryState("use20");
        }else if(bat2PowerLevel>=40&&bat2PowerLevel<60)
        {
            two.setBarreryState("use40");
        }else if(bat2PowerLevel>=60&&bat2PowerLevel<80)
        {
            two.setBarreryState("use60");
        }else if(bat2PowerLevel>=80&&bat2PowerLevel<96)
        {
            two.setBarreryState("use80");
        }else if(bat2PowerLevel >= 96 && bat2PowerLevel <= 100)
        {
            two.setBarreryState("useMax");
        }
    }

    /*!
    @Function    : setBarrery1UseType(bat1PowerLevel)
    @Description : 设置电池1使用类型
    @Author      : likun
    @Parameter   : bat1PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery1UseType(bat1PowerLevel)
    {
        one.setBarreyValue(bat1PowerLevel);
        if(bat1PowerLevel >= 0 && bat1PowerLevel < 20)
        {
            one.setBarreryState("use0");
        }else if(bat1PowerLevel >= 20 && bat1PowerLevel < 40)
        {
            one.setBarreryState("use20");
        }else if(bat1PowerLevel >= 40 && bat1PowerLevel < 60)
        {
            one.setBarreryState("use40");
        }else if(bat1PowerLevel >= 60 && bat1PowerLevel < 80)
        {
            one.setBarreryState("use60");
        }else if(bat1PowerLevel >= 80 && bat1PowerLevel < 96)
        {
            one.setBarreryState("use80");
        }else if(bat1PowerLevel >= 96 && bat1PowerLevel <= 100)
        {
            one.setBarreryState("useMax");
        }
    }

    /*!
    @Function    : setBarrery2UnUseType(bat2PowerLevel)
    @Description : 设置电池2未使用类型
    @Author      : likun
    @Parameter   : bat2PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery2UnUseType(bat2PowerLevel)
    {
        two.setBarreyValue(bat2PowerLevel);
        if(bat2PowerLevel >= 0 && bat2PowerLevel < 20)
        {
            two.setBarreryState("unuse0");
        }else if(bat2PowerLevel >=20 && bat2PowerLevel < 40)
        {
            two.setBarreryState("unuse20");
        }else if(bat2PowerLevel >= 40 && bat2PowerLevel < 60)
        {
            two.setBarreryState("unuse40");
        }else if(bat2PowerLevel >= 60 && bat2PowerLevel < 80)
        {
            two.setBarreryState("unuse60");
        }else if(bat2PowerLevel >= 80 && bat2PowerLevel < 96)
        {
            two.setBarreryState("unuse80");
        }else if(bat2PowerLevel >= 96 && bat2PowerLevel <= 100)
        {
            two.setBarreryState("unuseMax");
        }
    }

    /*!
    @Function    : setBarrery2UnUseType(bat2PowerLevel)
    @Description : 设置电池2未使用类型
    @Author      : likun
    @Parameter   : bat2PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery1UnUseType(bat1PowerLevel)
    {
        one.setBarreyValue(bat1PowerLevel);
        if(bat1PowerLevel >= 0 && bat1PowerLevel < 20)
        {
            one.setBarreryState("unuse0");
        }else if(bat1PowerLevel >= 20 && bat1PowerLevel < 40)
        {
            one.setBarreryState("unuse20");
        }else if(bat1PowerLevel >= 40 && bat1PowerLevel < 60)
        {
            one.setBarreryState("unuse40");
        }else if(bat1PowerLevel >= 60 && bat1PowerLevel < 80)
        {
            one.setBarreryState("unuse60");
        }else if(bat1PowerLevel >= 80 && bat1PowerLevel < 96)
        {
            one.setBarreryState("unuse80");
        }else if(bat1PowerLevel >= 96 && bat1PowerLevel <= 100)
        {
            one.setBarreryState("unuseMax");
        }
    }

    /*!
    @Function    : setBarrery1ChargingType(bat1PowerLevel)
    @Description : 设置电池1充电类型
    @Author      : likun
    @Parameter   : bat1PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery1ChargingType(bat1PowerLevel)
    {
        one.setBarreyValue(bat1PowerLevel);
        if(bat1PowerLevel >= 0 && bat1PowerLevel < 20)
        {
            one.setBarreryState("charging0");
        }else if(bat1PowerLevel >= 20 && bat1PowerLevel < 40)
        {
            one.setBarreryState("charging20");
        }else if(bat1PowerLevel >= 40 && bat1PowerLevel < 60)
        {
            one.setBarreryState("charging40");
        }else if(bat1PowerLevel >= 60 && bat1PowerLevel < 80)
        {
            one.setBarreryState("charging60");
        }else if(bat1PowerLevel >= 80 && bat1PowerLevel < 96)
        {
            one.setBarreryState("charging80");
        }else if(bat1PowerLevel >= 96 && bat1PowerLevel <= 100)
        {
            one.setBarreryState("chargingMax");
        }

    }
    /*!
    @Function    : setBarrery2ChargingType(bat2PowerLevel)
    @Description : 设置电池2充电类型
    @Author      : likun
    @Parameter   : bat2PowerLevel int 电量
    @Return      :
    @Output      :
    @Date        : 2024-08-25
*/
    function setBarrery2ChargingType(bat2PowerLevel)
    {
        two.setBarreyValue(bat2PowerLevel);
        if(bat2PowerLevel >= 0 && bat2PowerLevel < 20)
        {
            two.setBarreryState("charging0");
        }else if(bat2PowerLevel >= 20 && bat2PowerLevel < 40)
        {
            two.setBarreryState("charging20");
        }else if(bat2PowerLevel >= 40 && bat2PowerLevel < 60)
        {
            two.setBarreryState("charging40");
        }else if(bat2PowerLevel >= 60 && bat2PowerLevel < 80)
        {
            two.setBarreryState("charging60");
        }else if(bat2PowerLevel >= 80 && bat2PowerLevel < 96)
        {
            two.setBarreryState("charging80");
        }else if(bat2PowerLevel >= 96 && bat2PowerLevel <= 100)
        {
            two.setBarreryState("chargingMax");
        }
    }
}
