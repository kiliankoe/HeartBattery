//
//  AppDelegate.swift
//  HeartBattery
//
//  Created by Kilian Költzsch on 19/11/15.
//  Copyright © 2015 Kilian Költzsch. All rights reserved.
//

import Cocoa
import SwiftyTimer
import IYLoginItem

let kUseTemplateImages = "useTemplateImages"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	let totalHeartCount = 10
	let heartWidth = 18.0
	let heartHeight = 16.0
	
	@IBOutlet weak var statusMenu: NSMenu!
	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		statusItem.menu = statusMenu
		
		let defaults = [kUseTemplateImages: false]
		NSUserDefaults.standardUserDefaults().registerDefaults(defaults)
		
		refresh()
		
		NSTimer.every(5.minutes) { [unowned self] in
			self.refresh()
		}
	}
	
	// MARK: -
	
	func refresh() {
		let battery = HBBattery.readBatteryInfo()
		updateMenu(battery)
		updateStatusBar(battery)
	}
	
	/**
	Rebuild entire NSMenu with battery data and settings items
	
	- parameter battery: battery struct
	*/
	func updateMenu(battery: HBBattery) {
		statusMenu.removeAllItems()
		
		statusMenu.addItem(HBMenuItem(title: "\(battery.charge)% Charged", keyEquivalent: "", action: nil))
		
		statusMenu.addItem(HBMenuItem(title: "Time Remaining: \(battery.timeRemainingFormatted) Minutes", keyEquivalent: "", action: nil))
		
		let isCharging = battery.isCharging ? "Battery is Charging" : "Battery is Charged"
		statusMenu.addItem(HBMenuItem(title: isCharging, keyEquivalent: "", action: nil))
		
		let isACPowered = battery.isACPowered ? "Power Source: Power Adapter" : "Power Source: Battery"
		statusMenu.addItem(HBMenuItem(title: isACPowered, keyEquivalent: "", action: nil))
		
		
		statusMenu.addItem(NSMenuItem.separatorItem())
		
		//--------------------------------------------
		
		let useTemplateImages = NSUserDefaults.standardUserDefaults().boolForKey(kUseTemplateImages)
		let templatesMenuItem = HBMenuItem(title: "Use Template Images", keyEquivalent: "", action: { [unowned self] () -> () in
			if useTemplateImages {
				NSUserDefaults.standardUserDefaults().setObject(false, forKey: kUseTemplateImages)
			} else {
				NSUserDefaults.standardUserDefaults().setObject(true, forKey: kUseTemplateImages)
			}
			NSUserDefaults.standardUserDefaults().synchronize()
			self.refresh()
		})
		templatesMenuItem.state = useTemplateImages ? NSOnState : NSOffState
		statusMenu.addItem(templatesMenuItem)
		
		let loginMenuItem = HBMenuItem(title: "Start at Login", keyEquivalent: "", action: { () -> () in
			if NSBundle.mainBundle().isLoginItem() {
				NSBundle.mainBundle().removeFromLoginItems()
			} else {
				NSBundle.mainBundle().addToLoginItems()
			}
			self.refresh()
		})
		loginMenuItem.state = NSBundle.mainBundle().isLoginItem() ? NSOnState : NSOffState
		statusMenu.addItem(loginMenuItem)
		
		
		statusMenu.addItem(NSMenuItem.separatorItem())
		
		//--------------------------------------------
		
		statusMenu.addItem(HBMenuItem(title: "Open Energy Saver Preferences...", keyEquivalent: "", action: { () -> () in
			let url = NSURL(fileURLWithPath: "/System/Library/PreferencePanes/EnergySaver.prefPane")
			NSWorkspace.sharedWorkspace().openURL(url)
		}))
		
		statusMenu.addItem(NSMenuItem(title: "Quit", action: "terminate:", keyEquivalent: "q"))
	}
	
	/**
	Generate single icon image for use as the status bar icon.
	
	- parameter battery: battery struct
	*/
	func updateStatusBar(battery: HBBattery) {
		
		// How many hearts do we need?
		let fullHeartCount = Int(round(battery.charge/Double(totalHeartCount)))
		
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
		
		let useTemplateImages = NSUserDefaults.standardUserDefaults().boolForKey(kUseTemplateImages)
		icon.template = useTemplateImages ? true : false
		
		statusItem.image = icon // FIXME: .image is deprecated...
	}

}
