//
//  ViewController.swift
//  HeartBattery
//
//  Created by Kilian Költzsch on 19/11/15.
//  Copyright © 2015 Kilian Költzsch. All rights reserved.
//

import Cocoa
//import SystemKit

class ViewController: NSViewController {
	
	@IBOutlet weak var textField: NSTextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var battery = Battery()
		if battery.open() != kIOReturnSuccess { exit(0) }
		
		textField.stringValue = "" +
			"AC POWERED:      \(battery.isACPowered())" +
			"\nCHARGED:         \(battery.isCharged())" +
			"\nCHARGING:        \(battery.isCharging())" +
			"\nCHARGE:          \(battery.charge())%" +
			"\nCAPACITY:        \(battery.currentCapacity()) mAh" +
			"\nMAX CAPACITY:    \(battery.maxCapactiy()) mAh" +
			"\nDESGIN CAPACITY: \(battery.designCapacity()) mAh" +
			"\nCYCLES:          \(battery.cycleCount())" +
			"\nMAX CYCLES:      \(battery.designCycleCount())" +
			"\nTEMPERATURE:     \(battery.temperature())°C" +
			"\nTIME REMAINING:  \(battery.timeRemainingFormatted())"
		
		battery.close()
	}

	override var representedObject: AnyObject? {
		didSet {
		// Update the view, if already loaded.
		}
	}
}
