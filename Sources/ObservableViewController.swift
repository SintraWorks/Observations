//
//  ViewController.swift
//  Observations
//
//  Created by Antonio Nunes on 14/05/2019.
//  Copyright © 2019 SintraWorks. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this source code and associated documentation files (the "SourceCode"), to deal
//  in the SourceCode without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute copies of the SourceCode, and to
//  sell software using the SourceCode, and permit persons to whom the SourceCode is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the SourceCode.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

class ObservableViewController: UIViewController, Observable {
	enum Action {
		case button1Tapped
		case button2Tapped(message: String)
		case sliderDragged(value: Float)
		case isTrackingSlider(flag: Bool)
	}

    typealias Observed = Action
    
	let button1 = ObservableButton(type: .custom)
	let button2 = ObservableButton(type: .custom)
	let slider = ObservableSlider(frame: .zero)
	let swipeTarget = UILabel()
	var label = UILabel()
    var numberOfActions: Int = 0

	var observer: Observer<Observed>?

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

	func button2Pressed(message: String) {
        numberOfActions += 1

        self.label.text = "Action \(numberOfActions) on button 2"
		observer?.observe(.button2Tapped(message: message))
	}

	func sliderDragged(newValue: Float) {
		observer?.observe(.sliderDragged(value: newValue))
	}

	func trackingUpdate(isTracking: Bool) {
		observer?.observe(.isTrackingSlider(flag: isTracking))
	}

	private func setupButtons() {
		button1.setTitle("Action 1", for: .normal)
		button2.setTitle("Action 2", for: .normal)

		button1.showsTouchWhenHighlighted = true
		button2.showsTouchWhenHighlighted = true
		button1.layer.backgroundColor = UIColor.blue.cgColor
		button2.layer.backgroundColor = UIColor.blue.cgColor
		button1.layer.cornerRadius = 6.0
		button2.layer.cornerRadius = 6.0

		button1.translatesAutoresizingMaskIntoConstraints = false
		button2.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		swipeTarget.translatesAutoresizingMaskIntoConstraints = false
//		swipeTarget.alpha = 0

		slider.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(self.button1)
		view.addSubview(self.button2)
		view.addSubview(self.label)
		view.addSubview(self.swipeTarget)
		view.addSubview(slider)

		NSLayoutConstraint.activate([
			button1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			button1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 66),
			button2.topAnchor.constraint(equalTo: button1.bottomAnchor, constant: 16),
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 8),
			button1.widthAnchor.constraint(equalToConstant: 100),
			button2.widthAnchor.constraint(equalToConstant: 100),
			swipeTarget.leftAnchor.constraint(equalTo: view.leftAnchor),
			swipeTarget.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			slider.widthAnchor.constraint(equalToConstant: 200.0),
			slider.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 32)
			])
	}

	private func setupButtonObservers() {
		button1.addObserver(for: .touchUpInside, handler: { [weak self] in
			self?.button1Pressed()
		})

		button2.addObserver(for: .touchUpInside, handler: { [weak self] in
			self?.button2Pressed(message: "touchUpInside button 2")
		})
		button2.addObserver(for: .touchUpOutside, handler: { [weak self] in
			self?.button2Pressed(message: "touchUpOutside button 2")
		})

		slider.addObserver(for: [.valueChanged, .touchDown, .touchUpInside], handler: { [weak self] action in
			switch action {
			case .valueChanged(let newValue):
				self?.sliderDragged(newValue: newValue)
			case .isTrackingTouch(let isTracking):
				self?.trackingUpdate(isTracking: isTracking)
			}
		})
	}
}

