import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.Add Measures By Duration"
      description: "Add Measures By Duration"
      version: "1.0"

      onRun: {
            fillDefaultData()
            settingsDialog.visible = true
      }

      function fillDefaultData()
      {
            // Get duration
            durationMinTextField.text = Math.floor(curScore.duration / 60)
            durationSecTextField.text = curScore.duration % 60

            // Get a new cursor and rewind to score start
            var cursor = curScore.newCursor()
            cursor.rewind(Cursor.SCORE_START)

            // The tempo property is in bps so multiply by 60
            tempoTextField.text = cursor.tempo * 60;

            // Get time signature numerator/denominator
            sigNTextField.text = cursor.measure.timesigActual.numerator;
            sigDTextField.text = cursor.measure.timesigActual.denominator;
      }

      function addMeasures()
      {
            // get tempo and convert to bps
            var tempo = tempoTextField.text / 60

            // get duration and convert to seconds
            var duration = durationMinTextField.text * 60 + parseInt(durationSecTextField.text);

            // get time signature numerator
            var timeSigN = parseInt(sigNTextField.text);

            // beats in total = duration [s] * tempo [bps]
            var beatsInTotal = duration * tempo;

            // measures in total = beats in total / time sig numerator
            var measuresInTotal = Math.ceil(beatsInTotal / timeSigN)
            
            var measuresToBeAdded = measuresInTotal - curScore.nmeasures;

            if (measuresToBeAdded > 0) {
                  // start / end cmd to redraw score after measures have been added and 
                  // make undoing the operation possible
                  curScore.startCmd()
                  curScore.appendMeasures(measuresToBeAdded)
                  curScore.endCmd()
            }

            settingsDialog.visible = false
      }

      Dialog {
            id: settingsDialog
            title: qsTr("Add Measures By Duration")
            width: 320
            height: 125
            visible: false

            onVisibleChanged: function() {
                  if (!this.visible)
                        Qt.quit()
            }

            contentItem: Rectangle {
                  id: formbackground
                  width: 320
                  height: 125
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
                                    id: durationMinTextField
                                    maximumLength: 2
                                    implicitWidth: 32
                                    inputMask: "00"
                              }
                              Label {
                                    text: qsTr(" min  ")
                              }
                              TextField {
                                    id: durationSecTextField
                                    maximumLength: 2
                                    implicitWidth: 32
                                    //validator: IntValidator {}
                                    inputMask: "00"
                              }
                              Label {
                                    text: qsTr(" sec")
                              }
                        }

                        Label {
                              text: qsTr("Tempo")
                        }

                        Flow { 
                              TextField {
                                    id: tempoTextField
                                    readOnly: true
                                    maximumLength: 3
                                    implicitWidth: 48
                              }
                              Label {
                                    text: qsTr(" bpm")
                              }
                        }

                        Label {
                              text: qsTr("Time Signature")
                        }
                        Flow {
                              TextField {
                                    id: sigNTextField
                                    readOnly: true
                                    maximumLength: 2
                                    implicitWidth: 32
                              }
                              Label {
                                    text: " / "
                              }
                              TextField {
                                    id: sigDTextField
                                    maximumLength: 2
                                    readOnly: true
                                    implicitWidth: 32
                              }
                        }
                        Button {
                              id: addMeasuresButton
                              text: qsTr("Add Measures")
                              onClicked: addMeasures()
                        }
                  }
            }
      }
}
