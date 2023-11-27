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
          //let appleEventManager: NSAppleEventManager = NSAppleEventManager.shared()
    //NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleGetURLEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
//      NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(self.handleURLEvent(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
      
      NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(handleURLEventZ(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
      
//      NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(ProtocolHandlerPlugin.instance.handleURLEvent(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
//      
//      NSAppleEventManager.shared().setEventHandler(self, andSelector:#selector(ProtocolHandlerPlugin.instance.handleURLEvent(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
//        
//      
//      
//      let appleEventManager:NSAppleEventManager = NSAppleEventManager.shared()
//      appleEventManager.setEventHandler(self, andSelector: Selector(("handleURLEvent:_:with:")), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
      
//      NSAppleEventManager.shared().removeEventHandler(
//        forEventClass: AEEventClass(kInternetEventClass),
//          andEventID: AEEventID(kAEGetURL)
//      )
  }
    
    // func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
    //     print("yay");
    // }
    
    @objc public func handleURLEventZ(_ event: NSAppleEventDescriptor, with replyEvent: NSAppleEventDescriptor) {
        print("handleURLEvent2")
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else { return }
        
        //let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let w = self.mainFlutterWindow.contentViewController as! MacOSWindowUtilsViewController
        let c = w.flutterViewController
        let channel = FlutterMethodChannel(name: "protocol_handler", binaryMessenger: c.engine.binaryMessenger) // as!
        let args: NSDictionary = [
            "url": urlString,
        ]
        channel.invokeMethod("onProtocolUrlReceived", arguments: args)
    }

  // @objc func handleGetURL(event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor!) {
  //     print("handleURLEvent")
      
      //AppLinksMacosPlugin.handle(<#T##Notification#>)

      //AppLinksMacosPlugin.
//      ProtocolHandlerPlugin.
      // if let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue, let url = URL(string: urlString) {
      //     applicationHandle(url: url)
      // }
  }

  // @objc func handleGetURLEvent(_ event: NSAppleEventDescriptor, withReplyEvent: NSAppleEventDescriptor) {
    
  //     print("Asdasd")
  //     if let urlString = event.forKeyword(AEKeyword(keyDirectObject))?.stringValue {
  //         let url = URL(string: urlString)
  //         guard url != nil, let scheme = url!.scheme else {
  //             //some error
  //             return
  //         }
  //         if scheme.caseInsensitiveCompare("yourSchemeUrl") == .orderedSame {
  //             //your code
  //         }
  //     }
  // }
