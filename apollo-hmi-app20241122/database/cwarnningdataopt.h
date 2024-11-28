/******************************************************************************

  Copyright (C), 2017-2027, *******

 ******************************************************************************
  File Name     : cwarnningdataopt.h
  Version       : 1.0
  Author        : han
  Created       : 2024-08-13
  Last Modified :
  Description   :  header file
  Function List :
  History       :
  1.Date        : 2024-08-13
    Author      : fensnote
    Modification: Created file

******************************************************************************/

#ifndef CWARNNINGDATAOPT_H
#define CWARNNINGDATAOPT_H

#include <QObject>
#include <QSqlQuery>


/**
 * @brief The CWarnningDataOpt class
 */
class CWarnningDataOpt : public QObject
{
    Q_OBJECT
public:
    /**
     * @brief CWarnningDataOpt
     * @param parent
     */
    explicit CWarnningDataOpt(QObject *parent = nullptr);

signals:
private:
    QSqlQuery m_qWarningSetting;
};

#endif // CWARNNINGDATAOPT_H
