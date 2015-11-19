//
//  AppDelegate.swift
//  HeartBattery
//
//  Created by Kilian Költzsch on 19/11/15.
//  Copyright © 2015 Kilian Költzsch. All rights reserved.
//

import Cocoa
import SwiftyTimer

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	@IBOutlet weak var statusMenu: NSMenu!
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	
	@IBAction func quitClicked(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		statusItem.menu = statusMenu
		
		updateStatusBar()
		
		NSTimer.every(5.minutes) {
			self.updateStatusBar()
		}
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
	
	func updateStatusBar() {
		// Get battery information via SystemKit
		var battery = Battery()
		if battery.open() != kIOReturnSuccess { exit(0) }
		let charge = battery.charge()
		battery.close()
		
		// How many hearts do we need?
		let totalHeartCount = 10
		let fullHeartCount = Int(round(charge/Double(totalHeartCount)))
		let emptyHeartCount = totalHeartCount - fullHeartCount
		
		let heart_full = NSImage(named: "heart_full")
		let heart_empty = NSImage(named: "heart_empty")
	
//		let resultImage = NSImage(size: CGSizeMake())
		print("FULL: \(fullHeartCount)0%")
		var title = ""
		for _ in 0..<fullHeartCount {
			title += "❤️"
		}
		for _ in 0..<emptyHeartCount {
			title += "💔"
		}
		statusItem.title = title
	}

}
