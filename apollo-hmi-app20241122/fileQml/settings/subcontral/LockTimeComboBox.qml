import QtQuick 2.15
import QtQuick.Controls 2.5
import "../../mainFrame/assembly"

CustomComboBox {
    property  var  ms: [10,30,60]
    property  var  currentValue: ms[currentIndex]
    id:lockTime
    signal sendLockTimeIndex(int index);
    models:[]
    currentText: ms[currentIndex]
    Component.onCompleted:
    {
        lockTime.models=ms;
        currentIndex = 1;
    }

    Connections
    {
        target: lockTime
        function onSendLockTimeIndex(index)
        {
            lockTime.currentIndex=index;
            lockTime.changeListViewIndex();
        }
    }
    Connections
    {
        target:lockTime
        function onSendIndex(index)
        {
            lockTime.currentText=ms[index];
            sendLockTimeIndex(index);
        }
    }
    function setLockTime(text)
    {
        if(!text in ms)
        {
            closePage.open(pubCode.messageType.Information,`无效的锁定时间:${text}`);
            return;
        }
        for(var i=0;i<ms.length;i++)
        {
            if(ms[i]===text)
            {
                lockTime.sendLockTimeIndex(i);
                lockTime.currentText=text;
                return;
            }
        }
    }

}
