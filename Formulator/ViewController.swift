//
//  ViewController.swift
//  Formulator
//
//  Created by Robin Malhotra on 06/08/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	var prop1 = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		let button = UIButton()
		button.actionHandle(controlEvents: UIControlEvents.TouchUpInside,
		                    ForAction:{() -> Void in
								self.prop1 +=1
								print(self.prop1)
								
		})
		button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		view.addSubview(button)
		button.setTitle("ASDfasd", forState: .Normal)
		button.setTitleColor(UIColor.blueColor(), forState: .Normal)
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}



extension UIButton {
	
	
	private func actionHandleBlock(action:(() -> Void)? = nil) {
		if let closure = action {
			closure()
		}
	}
	
	@objc private func triggerActionHandleBlock() {
		self.actionHandleBlock()
	}
	
	func actionHandle(controlEvents control :UIControlEvents, ForAction action:() -> Void) {
		self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), forControlEvents: control)
	}
}

