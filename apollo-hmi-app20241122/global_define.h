#ifndef GLOBAL_DEFINE_H
#define GLOBAL_DEFINE_H

#include <QString>
#ifndef __arm__
#define GLOBAL_SIMULATION  //定义后生成模块数据
#endif
#define MAX_WARNING_TYPE_COUNT 3
#define ALARM_ENABLED     1
#define AUDIO_ENABLED       1

//#define BOARD_TQ     1

//mute 0-不可被静音, 1-可被静音
//latching 0-栓锁,必须用户清除才能消除, 1-非栓锁，可自动消除，用户删除不移除
//trigger on run 0-非运行时才触发, 1-运行时才触发,停止时移除

namespace Glb_define {
//warnning name defined
extern const QString conWarnSysemErr1;   // ！！！系统故障1
extern const QString conWarnSysemErr2;   // ！！！系统故障2
extern const QString conWarnMotorDisConnected;  // ！！！电机未连接
extern const QString conWarnMotorFailure;   // ！！！电机故障
extern const QString conWarnMotorTempHigh;  // ！！！电机温度高
extern const QString conWarnMotorStopped;   // ！！！电机停止
extern const QString conWarnPumpUninstalled;    // ！泵头未安装
extern const QString conWarnMotorCurrentHigh;   // ！！！电机驱动电流过高
extern const QString conWarnMotoSpeedHigher;    // ！！！转速过高
extern const QString conWarnMotorSpeedLower;    // ！！！转速过低
extern const QString conWarnFlowSensorDisconnected; // ！！！流量传感器未连接
extern const QString conWarnFlowSensorFailure;  // ！！！流量传感器故障
extern const QString conWarnFlowHigher; // ！！！流量过高
extern const QString conWarnFlowLower;  // ！！！流量过低
extern const QString conWarnBatteryEmpty;   // ！！！电池即将耗尽
extern const QString conWarnBatteryLow; // ！！电池电量低
extern const QString conWarnBatteryPowered; // ！电池供电中
extern const QString conWarnBatteryNotFound;    // ！！！未发现电池
extern const QString conWarnBatteryTempHigh;    // ！！！电池温度过高
extern const QString conWarnBatteryChangeFailed; // ！！！电池充电失败
extern const QString conWarnBatteryNeedMantience;    // ！！电池需要维护
extern const QString conWarnMotorSpeedAbnormal; // !!!转速异常
extern const QString conWarnBubbleInPipe;    //!!管路有气泡

//action type defined
extern const QString conActPowerOn; // 开机
extern const QString conActPowerOff; // 关机
extern const QString conActStartPump; // 启动泵
extern const QString conActUpdateSpeed; // 更新转速
extern const QString conActSetSpeedRange; // 设置转速报警上限
extern const QString conActSetFlowRange; // 设置流量报警上限
extern const QString conActInstallPump; // 安装泵头
extern const QString conActUninstallPump; // 拆卸泵头
extern const QString conActInstallFlowSensor; // 安装流量传感器
extern const QString conActUninstallFlowSensor; // 拆卸流量传感器
extern const QString conActStopPump; // 关闭泵
extern const QString conActExportLog; // 导出记录
}

#endif // GLOBAL_DEFINE_H
