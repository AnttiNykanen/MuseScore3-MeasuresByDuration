import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
// import Qt.labs.settings 1.0
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.pluginName"
      description: "Description goes here"
      version: "1.0"
      onRun: {
            settingsDialog.visible = true
      }

      Dialog {
            id: settingsDialog
            title: qsTr("Add Measures By Duration")
            width: 320
            height: 100
            visible: false

            contentItem: Rectangle {
                  id: formbackground
                  width: grid.width + 20
                  height: grid.height + 20
                  color: "lightgrey"
                  GridLayout {
                        id: grid
                        columns: 2
                        anchors.fill: parent
                        anchors.margins: 10
                        Label {
                              text: qsTr("Duration")
                        }
                        Flow {
                              TextField {
                                    id: minutesTextField
                              }
                              Label {
                                    text: qsTr("min")
                              }
                              TextField {
                                    id: secondsTextField
                              }
                              Label {
                                    text: qsTr("sec")
                              }
                        }

                        Label {
                              text: qsTr("Tempo")
                        }
                        TextField {
                              id: tempoTextField
                        }

                        Label {
                              text: qsTr("Time Signature")
                        }
                        Flow {
                              TextField {
                                    id: sigUpperTextField
                              }
                              Label {
                                    text: "/"
                              }
                              TextField {
                                    id: sigLowerTextField
                              }
                        }
                        CheckBox {
                              id: appendCheckBox
                              text: qsTr("Append")
                        }
                        Button {
                              id: addMeasuresButton
                              text: qsTr("Add Measures")
                        }
                  }
            }
      }
}
