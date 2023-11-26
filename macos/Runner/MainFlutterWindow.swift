import Cocoa
import FlutterMacOS
import macos_window_utils

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    self.titleVisibility = NSWindow.TitleVisibility.hidden
    self.titlebarAppearsTransparent = true
    self.isMovableByWindowBackground = true
//      self.styleMask = []
//      //self.styleMask.insert(.texturedBackground)
//      self.styleMask.insert(.resizable)
//
//      self.standardWindowButton(.closeButton)?.isHidden = true
//              self.standardWindowButton(.miniaturizeButton)?.isHidden = true
//              self.standardWindowButton(.zoomButton)?.isHidden = true
//              self.standardWindowButton(.fullScreenButton)?.isHidden = true

    let flutterViewController = FlutterViewController.init()
    // let flutterViewController.titleVisibility = NSWindow.TitleVisibility.hidden
    // let flutterViewController.titlebarAppearsTransparent = true


    //Add these code to your MainFlutterWindow.swift file
    flutterViewController.backgroundColor = .clear
    // flutterViewController.isOpaque = false

    self.isOpaque = false
    self.backgroundColor = .clear
      
    let visualEffectView = NSVisualEffectView()

     visualEffectView.material = .underWindowBackground  // The material of the view. This sets the blur effect.
     visualEffectView.blendingMode = .behindWindow  // The blending mode. This makes the blur effect appear behind the window.
     visualEffectView.state = .active  // The state. This makes the blur effect active.
    flutterViewController.view.addSubview(visualEffectView, positioned: .below, relativeTo: flutterViewController.view)
     visualEffectView.translatesAutoresizingMaskIntoConstraints = false
     NSLayoutConstraint.activate([
      visualEffectView.topAnchor.constraint(equalTo: flutterViewController.view.topAnchor),
      visualEffectView.bottomAnchor.constraint(equalTo: flutterViewController.view.bottomAnchor),
      visualEffectView.leadingAnchor.constraint(equalTo: flutterViewController.view.leadingAnchor),
      visualEffectView.trailingAnchor.constraint(equalTo:flutterViewController.view.trailingAnchor),
     ])



    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: false)

    // let windowFrame = self.frame
    // let macOSWindowUtilsViewController = MacOSWindowUtilsViewController()
    // self.contentViewController = macOSWindowUtilsViewController
    // self.setFrame(windowFrame, display: true)

    // /* Initialize the macos_window_utils plugin */
    // MainFlutterWindowManipulator.start(mainFlutterWindow: self)

    // RegisterGeneratedPlugins(registry: macOSWindowUtilsViewController.flutterViewController)



    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
