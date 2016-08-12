//
//  ViewController.swift
//  Formulator
//
//  Created by Robin Malhotra on 06/08/16.
//  Copyright © 2016 Robin Malhotra. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

	var prop1 = 0
	override func viewDidLoad() {
		super.viewDidLoad()
		let button = FormButton()
		button.primaryClosure = {
			self.prop1 += 1
			print(self.prop1)
		}
		button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
		view.addSubview(button)
		button.setTitle("ASDfasd", forState: .Normal)
		button.setTitleColor(UIColor.blueColor(), forState: .Normal)
		// Do any additional setup after loading the view, typically from a nib.
		
		let textField = FormTextField(frame: CGRect(x: 0, y: 300, width: 300, height: 50))
		textField.validateText = {
			print((textField.text?.containsString("asd"))!)
			return (textField.text?.containsString("asd"))!
		}
		
		textField.gatherSuggestions = {
			
			Alamofire.request(.GET, "https://a4825bf2.ngrok.io", parameters: nil, encoding: .JSON, headers: nil).validate().responseJSON(completionHandler: { (response) in
				switch response.result {
				case .Success:
					if let value = response.result.value {
						let json = JSON(value)
						print("JSON: \(json)")
					}
					case .Failure(let error):
						print(error)
					}
			})
		}
		textField.borderStyle = .Bezel
		view.addSubview(textField)
		let red = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
		red.backgroundColor = UIColor.redColor()
		textField.addSubview(red)
		textField.clipsToBounds = false
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

typealias EmptyClosure = () -> ()
typealias ValidationClosure = () -> Bool
typealias SuggestionsClosure = () -> [String]

class FormButton: UIButton {
	
	var primaryClosure: EmptyClosure = {} {
		didSet {
			self.removeTarget(nil, action: nil, forControlEvents: .PrimaryActionTriggered)
			self.addTarget(self, action: #selector(FormButton.buttonTapped(_:)),forControlEvents: .PrimaryActionTriggered)
		}
	}
	
	
	@objc private func buttonTapped(sender: UIButton) {
		primaryClosure()
	}
}

class FormTextField: UITextField {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.initialize()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.initialize()
	}
	
	func initialize() {
		self.addTarget(self, action: #selector(FormTextField.textFieldChanged(_:)),forControlEvents: .EditingChanged)
	}
	
	var validateText: ValidationClosure = {return false}
	
	var gatherSuggestions: EmptyClosure = {}
	
	@objc private func textFieldChanged(sender: UIButton) {
		validateText()
		gatherSuggestions()
	}
}