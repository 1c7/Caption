//
//  AppDelegate.swift
//  Caption
//
//  Created by Bright on 7/29/17.
//  Copyright © 2017 Bright. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if flag == false {
            
            for window in sender.windows {
                
                if (window.delegate?.isKind(of: CaptionWindowController.self)) == true {
                    window.makeKeyAndOrderFront(self)
                }
            }
        }
        
        return true

    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func openVideoFile(_ sender: NSMenuItem) {
        if let vc = NSApplication.shared.mainWindow?.contentViewController as? ViewController {
            vc.openFile(self)
        }
    }
    
    @IBAction func saveSRTFile(_ sender: NSMenuItem) {
        if let vc = NSApplication.shared.mainWindow?.contentViewController as? ViewController {
            vc.saveSRT()
        }

    }
    
    


}


