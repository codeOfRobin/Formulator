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


extension String: Suggestable {
	var textualDescription: String {
		return self
	}
}

protocol Suggestable {
	var textualDescription: String { get }
}

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
			
			Alamofire.request(.GET, "https://08e7c592.ngrok.io", parameters: nil, encoding: .JSON, headers: nil).validate().responseJSON(completionHandler: { (response) in
				switch response.result {
				case .Success:
					if let value = response.result.value {
						let jsonResult = JSON(value)
						if let suggestions = jsonResult.array {
							let suggestableArray: [Suggestable] = suggestions.map({ (suggestion) -> Suggestable in
								return suggestion.string!
							})
							let nonOptionalSuggestions = suggestableArray.flatMap {$0}
							textField.showSuggestions(nonOptionalSuggestions)
 						}
					}
					case .Failure(let error):
						print(error)
					}
			})
		}
		textField.borderStyle = .Bezel
		view.addSubview(textField)
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






class FormTextField: UITextField, UITableViewDelegate, UITableViewDataSource {
	
	let tableView = UITableView(frame: CGRectZero)
	var suggestions: [Suggestable] = []
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.clipsToBounds = false
		tableView.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: 100)
		tableView.layer.borderColor = UIColor.blueColor().CGColor
		tableView.layer.borderWidth = 1.0
		tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
		tableView.dataSource = self
		tableView.delegate = self
		self.initialize()
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return suggestions.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		cell.textLabel?.text = suggestions[indexPath.row].textualDescription
		return cell
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
	
	func showSuggestions(suggestionObjects: [Suggestable]) {
		self.suggestions = suggestionObjects
		self.superview?.addSubview(tableView)
		tableView.reloadData()
	}
	
	@objc private func textFieldChanged(sender: UIButton) {
		validateText()
		gatherSuggestions()
		
	}
}