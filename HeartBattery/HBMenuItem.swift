//
//  HBMenuItem.swift
//  HeartBattery
//
//  Created by Kilian Költzsch on 19/11/15.
//  Copyright © 2015 Kilian Költzsch. All rights reserved.
//

import Cocoa

class HBMenuItem: NSMenuItem {
	var actionClosure: (() -> ())?
	
	init(title: String, keyEquivalent: String, action: (() -> ())?) {
		if let action = action {
			self.actionClosure = action
			super.init(title: title, action: "action:", keyEquivalent: keyEquivalent)
		} else {
			super.init(title: title, action: nil, keyEquivalent: keyEquivalent)
		}
		
		self.target = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func action(sender: NSMenuItem) {
		self.actionClosure?()
	}
}
