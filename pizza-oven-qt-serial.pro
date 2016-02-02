QT = core
QT += serialport

CONFIG += console
CONFIG -= app_bundle

TARGET = pizza-oven-qt-serial
TEMPLATE = app

HEADERS += \
    serialportreader.h

SOURCES += \
    main.cpp \
    serialportreader.cpp
