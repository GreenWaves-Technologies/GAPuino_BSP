# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'Desktop/gui/layout_wifi.ui'
#
# Created by: PyQt4 UI code generator 4.11.4
#
# WARNING! All changes made in this file will be lost!

from PyQt4 import QtCore, QtGui

try:
    _fromUtf8 = QtCore.QString.fromUtf8
except AttributeError:
    def _fromUtf8(s):
        return s

try:
    _encoding = QtGui.QApplication.UnicodeUTF8
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig, _encoding)
except AttributeError:
    def _translate(context, text, disambig):
        return QtGui.QApplication.translate(context, text, disambig)

class Ui_Camera_WiFIInterface(object):
    def setupUi(self, Camera_WiFIInterface):
        Camera_WiFIInterface.setObjectName(_fromUtf8("Camera_WiFIInterface"))
        Camera_WiFIInterface.resize(943, 506)
        self.centralwidget = QtGui.QWidget(Camera_WiFIInterface)
        self.centralwidget.setObjectName(_fromUtf8("centralwidget"))
        self.ConnectButton = QtGui.QPushButton(self.centralwidget)
        self.ConnectButton.setEnabled(True)
        self.ConnectButton.setGeometry(QtCore.QRect(480, 90, 98, 27))
        self.ConnectButton.setCheckable(True)
        self.ConnectButton.setAutoDefault(False)
        self.ConnectButton.setDefault(False)
        self.ConnectButton.setFlat(False)
        self.ConnectButton.setObjectName(_fromUtf8("ConnectButton"))
        self.camera_wid = QtGui.QWidget(self.centralwidget)
        self.camera_wid.setGeometry(QtCore.QRect(70, 50, 360, 360))
        self.camera_wid.setObjectName(_fromUtf8("camera_wid"))
        self.label_3 = QtGui.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(70, 20, 181, 17))
        self.label_3.setObjectName(_fromUtf8("label_3"))
        self.listWidget = QtGui.QListWidget(self.centralwidget)
        self.listWidget.setGeometry(QtCore.QRect(620, 40, 271, 301))
        self.listWidget.setObjectName(_fromUtf8("listWidget"))
        self.label_5 = QtGui.QLabel(self.centralwidget)
        self.label_5.setGeometry(QtCore.QRect(650, 20, 181, 17))
        self.label_5.setObjectName(_fromUtf8("label_5"))
        self.SaveButton = QtGui.QPushButton(self.centralwidget)
        self.SaveButton.setEnabled(True)
        self.SaveButton.setGeometry(QtCore.QRect(480, 130, 98, 27))
        self.SaveButton.setCheckable(True)
        self.SaveButton.setAutoDefault(False)
        self.SaveButton.setDefault(False)
        self.SaveButton.setFlat(False)
        self.SaveButton.setObjectName(_fromUtf8("SaveButton"))
        Camera_WiFIInterface.setCentralWidget(self.centralwidget)
        self.menubar = QtGui.QMenuBar(Camera_WiFIInterface)
        self.menubar.setEnabled(False)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 943, 25))
        self.menubar.setObjectName(_fromUtf8("menubar"))
        Camera_WiFIInterface.setMenuBar(self.menubar)
        self.statusbar = QtGui.QStatusBar(Camera_WiFIInterface)
        self.statusbar.setObjectName(_fromUtf8("statusbar"))
        Camera_WiFIInterface.setStatusBar(self.statusbar)

        self.retranslateUi(Camera_WiFIInterface)
        QtCore.QMetaObject.connectSlotsByName(Camera_WiFIInterface)

    def retranslateUi(self, Camera_WiFIInterface):
        Camera_WiFIInterface.setWindowTitle(_translate("Camera_WiFIInterface", "Camera GUI", None))
        self.ConnectButton.setText(_translate("Camera_WiFIInterface", "Connect", None))
        self.label_3.setText(_translate("Camera_WiFIInterface", "Camera Display", None))
        self.label_5.setText(_translate("Camera_WiFIInterface", "Log ", None))
        self.SaveButton.setText(_translate("Camera_WiFIInterface", "Save", None))

