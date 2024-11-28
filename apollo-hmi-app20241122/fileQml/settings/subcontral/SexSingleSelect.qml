import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import "../../mainFrame/assembly"
/*! @File        : SexSingleSelect.qml
 *  @Brief       : 性别控件
 *  @Author      : likun
 *  @Date        : 2024-08-18
 *  @Version     : v1.0
*/

Rectangle
{
    property int sexIndex;
    id:rectSex
    width:52+14+166
    height: 64
    color:"transparent"
    RowLayout
    {
        id:rowLayout
        spacing: 14
        PublicConstText
        {
            id:constTextSex
            textContent: "性别"
        }
        CustomSingleSelectButton
        {
            id:sexSingleSelect
            property bool running: false
            property int startPos : 0
            property int endPos : sexSingleSelect.width-faceRect.width
            leftTxt: "男"
            rightTxt: "女"
            /*!
    @Function    : onSendSelectIndex
    @Description : 接收选中的索引信号
    @Author      : likun
    @Parameter   : index int 索引
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
            onSendSelectIndex:
            {
                sexIndex=index;
                if(index==0)
                {
                    if(faceRect.x==0)
                    {
                        sexSingleSelect.startPos=0
                        sexSingleSelect.endPos=0
                    }
                    else if(faceRect.x==sexSingleSelect.width-faceRect.width)
                    {
                        sexSingleSelect.startPos=sexSingleSelect.width-faceRect.width
                        sexSingleSelect.endPos=0
                    }
                }
                else if(index==1)
                {
                    if(faceRect.x==0)
                    {
                        sexSingleSelect.startPos=0
                        sexSingleSelect.endPos=sexSingleSelect.width-faceRect.width
                    }
                    else if(faceRect.x==sexSingleSelect.width-faceRect.width)
                    {
                        sexSingleSelect.startPos=sexSingleSelect.width-faceRect.width
                        sexSingleSelect.endPos=sexSingleSelect.width-faceRect.width
                    }
                }
                sexSingleSelect.running=true;
                animationX.start();
                mainWindow.havePatientValueChanged();
            }

            Rectangle
            {
                id:faceRect
                width: 76
                height: 56
                color:"#797979"
                opacity: 0.5
                x:0
                y:4
               PropertyAnimation on x
               {
                 id: animationX;
         //        target:faceRect;
                 from:sexSingleSelect.startPos
                 to: sexSingleSelect.endPos;
                 duration: 500
                 easing.type: Easing.OutCubic;
                 running:sexSingleSelect.running
               }
            }
        }
    }
    /*!
    @Function    : sex()
    @Description : 获取性别
    @Author      : likun
    @Parameter   :
    @Return      : sex string 性别
    @Output      :
    @Date        : 2024-08-18
*/
    function sex()
    {
        if(sexIndex==0)
            return "男";
        if(sexIndex==1)
            return "女";
    }
    /*!
    @Function    : setSex(sexStr)
    @Description : 设置性别
    @Author      : likun
    @Parameter   : sexStr string 性别
    @Return      :
    @Output      :
    @Date        : 2024-08-18
*/
    function setSex(sexStr)
    {
        if(sexStr==="男")
        {
            sexSingleSelect.sendSelectIndex(0);
            return ;
        }
        if(sexStr=="女")
        {
            sexSingleSelect.sendSelectIndex(1);
            return ;
        }
    }
}


