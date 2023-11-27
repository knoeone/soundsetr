import Cocoa
import FlutterMacOS
import protocol_handler
import app_links
import macos_window_utils

@NSApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    NSApp.hide(self)
    return true
  }

  override func applicationWillFinishLaunching(_ notification: Notification) {
    super.applicationWillFinishLaunching(notification)
      NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(handleURLEvent(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
  }

  @objc public func handleURLEvent(_ event: NSAppleEventDescriptor, with replyEvent: NSAppleEventDescriptor) {
    guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else { return }
    
    let window = self.mainFlutterWindow.contentViewController as! MacOSWindowUtilsViewController
    let messenger = window.flutterViewController.engine.binaryMessenger
    let channel = FlutterMethodChannel(name: "protocol_handler", binaryMessenger: messenger)
    let args: NSDictionary = [
        "url": urlString,
    ]
    channel.invokeMethod("onProtocolUrlReceived", arguments: args)
  }
}