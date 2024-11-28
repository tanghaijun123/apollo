import QtQuick 2.15

/*! @File        : ErrorCode.qml
 *  @Brief       : 错误码
 *  @Author      : likun
 *  @Date        : 2024-08-25
 *  @Version     : v1.0
*/
Item {
    enum ErrorCode
    {
        RunRecordSetMaxRowError=1,
        RunRecordGetMaxPageError,
        RunRecordNoneNumberError,
        OperationRecordSetMaxRowError,
        OperationRecordGetMaxPageError,
        OperationRecordNoneNumberError,
        WarningRecordSetMaxRowError,
        WarningRecordGetMaxPageError,
        WarningRecordNoneNumberError
    }

}
