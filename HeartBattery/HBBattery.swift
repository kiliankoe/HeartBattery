//
//  HBBattery.swift
//  HeartBattery
//
//  Created by Kilian Költzsch on 20/11/15.
//  Copyright © 2015 Kilian Költzsch. All rights reserved.
//

import Foundation

struct HBBattery {
	let currentCapacity: Int
	let maxCapacity: Int
	let designCapacity: Int
	let cycleCount: Int
	let designCycleCount: Int
	let isACPowered: Bool
	let isCharging: Bool
	let isCharged: Bool
	let charge: Double
	let timeRemaining: Int
	let timeRemainingFormatted: String
	let temperature: Double
	
	static func readBatteryInfo() -> HBBattery {
		// Get battery information via SystemKit
		var battery = Battery()
		if battery.open() != kIOReturnSuccess { exit(0) }
		defer { battery.close() }
		
		let systemBattery = HBBattery(currentCapacity: battery.currentCapacity(),
			maxCapacity: battery.maxCapactiy(), // There's a typo, umm... yeah... PR that someday.
			designCapacity: battery.designCapacity(),
			cycleCount: battery.cycleCount(),
			designCycleCount: battery.designCycleCount(),
			isACPowered: battery.isACPowered(),
			isCharging: battery.isCharging(),
			isCharged: battery.isCharged(),
			charge: battery.charge(),
			timeRemaining: battery.timeRemaining(),
			timeRemainingFormatted: battery.timeRemainingFormatted(),
			temperature: battery.temperature())
		
		return systemBattery
	}
}
