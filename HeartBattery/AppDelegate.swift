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
	
	let totalHeartCount = 10
	let heartWidth = 18.0
	let heartHeight = 16.0
	
	@IBOutlet weak var statusMenu: NSMenu!
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	
	@IBAction func quitClicked(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		statusItem.menu = statusMenu
		
		updateStatusBar()
		
		NSTimer.every(5.minutes) { [unowned self] in
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
		let fullHeartCount = Int(round(charge/Double(totalHeartCount)))
		
		// Composite a single image to display in statusbar
		let heartFull = NSImage(named: "heart_full")!
		let heartEmpty = NSImage(named: "heart_empty")!
		
		let size = CGSizeMake(CGFloat((Int(heartWidth)+2)*totalHeartCount), CGFloat(heartHeight))
		let icon = NSImage(size: size)
		icon.lockFocus()
		for i in 0..<fullHeartCount {
			var rect = NSZeroRect
			rect.size = CGSizeMake(CGFloat(heartWidth), CGFloat(heartHeight))
			heartFull.drawAtPoint(CGPointMake((CGFloat(i*Int((2+heartWidth)))), 0), fromRect: rect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0)
		}
		for i in fullHeartCount..<totalHeartCount {
			var rect = NSZeroRect
			rect.size = CGSizeMake(CGFloat(heartWidth), CGFloat(heartHeight))
			heartEmpty.drawAtPoint(CGPointMake((CGFloat(i*Int((2+heartWidth)))), 0), fromRect: rect, operation: NSCompositingOperation.CompositeSourceOver, fraction: 1.0)
		}
		icon.unlockFocus()
		
		statusItem.image = icon // FIXME: .image is deprecated...
	}

}
