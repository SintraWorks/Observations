//
//  ViewController.swift
//  RxLight
//
//  Created by Antonio Nunes on 14/05/2019.
//  Copyright © 2019 SintraWorks. All rights reserved.
//

import UIKit

class ObservableViewController: UIViewController, Observable {
	enum Action {
		case button1Tapped
		case button2Tapped(message: String)
	}

    typealias Thing = Action
    
	let button1 = ObservableButton(type: .custom)
	let button2 = ObservableButton(type: .custom)
	var label = UILabel()
    var numberOfActions: Int = 0

	var observer: Observer<Thing>?

	override func viewDidLoad() {
		super.viewDidLoad()

		setupButtons()
		setupButtonObservers()
	}

	func button1Pressed() {
        numberOfActions += 1
        self.label.text = "Action \(numberOfActions) on button 1"
		observer?.observe(.button1Tapped)
	}

	func button2Pressed() {
        numberOfActions += 1

        self.label.text = "Action \(numberOfActions) on button 2"
		observer?.observe(.button2Tapped(message: "Remote action on button 2"))
	}

	private func setupButtons() {
		self.button1.set(title: "Action 1", for: .normal)
		self.button2.set(title: "Action 2", for: .normal)

		self.button1.translatesAutoresizingMaskIntoConstraints = false
		self.button2.translatesAutoresizingMaskIntoConstraints = false
		self.label.translatesAutoresizingMaskIntoConstraints = false

		self.view.addSubview(self.button1)
		self.view.addSubview(self.button2)
		self.view.addSubview(self.label)

		NSLayoutConstraint.activate([
			self.button1.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.button2.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.button1.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 66),
			self.button2.topAnchor.constraint(equalTo: self.button1.bottomAnchor, constant: 16),
			self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.label.topAnchor.constraint(equalTo: self.button2.bottomAnchor, constant: 8),
			self.button1.widthAnchor.constraint(equalToConstant: 100),
			self.button2.widthAnchor.constraint(equalToConstant: 100)
			])
	}

	private func setupButtonObservers() {
		button1.observers.append(
			Observer(handler: { eventType in
                switch eventType {
                case .touchUpInside:
                    self.button1Pressed()
                case .touchUpOutside:
                    print("Tap canceled")
                case .touchDown:
                    print("Tap down")
                case .touchDownRepeat:
                    print("Multitap!")
                default:
                    break
                }
			})
		)

		button2.observers.append(
			Observer(handler: { eventType in
				if eventType.contains(.touchUpInside) {
					self.button2Pressed()
				}
			})
		)
	}
}

