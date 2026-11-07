//@ pragma AppId org.omarchy.screensaver
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

ShellRoot {
  id: root
  property double started: Date.now()
  property real seconds: 0
  property bool armed: false
  Timer { interval: 800; running: true; onTriggered: root.armed = true }
  Timer {
    interval: 33; running: true; repeat: true
    onTriggered: root.seconds = (Date.now() - root.started) / 1000
  }
  IpcHandler { target: "screensaver"; function quit(): void { Qt.quit() } }
  Variants {
    model: Quickshell.screens
    PanelWindow {
      id: window
      required property var modelData
      screen: modelData
      visible: true
      anchors { top: true; bottom: true; left: true; right: true }
      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.namespace: "org.omarchy.screensaver"
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
      color: "#060a06"
      Image { id: logo; source: "assets/logo.png"; visible: false }
      ShaderEffect {
        anchors.fill: parent
        property var source: logo
        property real seconds: root.seconds
        property real aspect: width / Math.max(1, height)
        property real pixelHeight: height
        fragmentShader: "assets/crt.frag.qsb"
      }
      Item {
        anchors.fill: parent
        anchors.margins: Math.max(24, parent.width * 0.035)
        opacity: 0.65 + Math.sin(root.seconds * 0.7) * 0.06
        Text {
          anchors.left: parent.left; anchors.top: parent.top
          text: "APHEX TWIN  /  SYRO\nANALOG SIGNAL GENERATOR"
          font.family: "Iosevka"; font.pixelSize: 14; font.letterSpacing: 3
          lineHeight: 1.5; color: "#bfd630"
        }
        Text {
          anchors.right: parent.right; anchors.top: parent.top
          text: "TRANSMISSION  0" + (Math.floor(root.seconds / 12) % 9 + 1) + "\n" + Qt.formatDateTime(new Date(root.started + root.seconds * 1000), "HH:mm:ss")
          font.family: "Iosevka"; font.pixelSize: 14; font.letterSpacing: 2
          horizontalAlignment: Text.AlignRight; lineHeight: 1.5; color: "#bfd630"
        }
        Text {
          anchors.bottom: parent.bottom; anchors.left: parent.left
          text: "●  LIVE  /  33⅓ RPM"
          font.family: "Iosevka"; font.pixelSize: 12; font.letterSpacing: 2; color: "#bfd630"
        }
        Text {
          anchors.bottom: parent.bottom; anchors.right: parent.right
          text: "MOVE TO WAKE"
          font.family: "Iosevka"; font.pixelSize: 12; font.letterSpacing: 3; color: "#bfd630"
        }
      }
      Item {
        anchors.fill: parent
        focus: true
        Component.onCompleted: forceActiveFocus()
        Keys.onPressed: event => { if (root.armed) { event.accepted = true; Qt.quit() } }
      }
      MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.BlankCursor
        property real lastX: -1
        property real lastY: -1
        onPositionChanged: mouse => {
          if (root.armed && lastX >= 0 && Math.abs(mouse.x - lastX) + Math.abs(mouse.y - lastY) > 3) Qt.quit()
          lastX = mouse.x; lastY = mouse.y
        }
        onClicked: if (root.armed) Qt.quit()
        onWheel: if (root.armed) Qt.quit()
      }
    }
  }
}
