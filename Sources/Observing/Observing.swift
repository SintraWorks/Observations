//
//  Observing.swift
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

/// An object that can observe instances of `Observation`.
final class Observer<Observation> {
	let handler: (Observation) -> Void

	func observe(_ thing: Observation) {
		handler(thing)
	}

	init(handler: @escaping (Observation) -> Void) {
		self.handler = handler
	}
}

/// A protocol for observables that can service a single `Observer`.
protocol Observable {
	associatedtype Observation
	var observer: Observer<Observation>? { get set }
}

/// A protocol for observables that can service multiple `Observer`s.
protocol MultiObservable {
	associatedtype Observation
	var observers: [Observer<Observation>] { get set }
}

extension MultiObservable {
	/// Add an observer by passing in a handler for the observation.
	/// - Parameter handler: A function that takes an Observation.
	/// - Returns: The newly created observer.
	@discardableResult mutating func addObserver(for handler: @escaping (Observation) -> Void) -> Observer<Observation> {
		let observer = Observer<Observation>(handler: handler)
		observers.append(observer)
		return observer
	}

	/// Add an observer.
	/// - Parameter observer: An Observer.
	mutating func add(observer: Observer<Observation>) {
		observers.append(observer)
	}

	/// Remove all instances of a specific observer.
	/// - Parameter observer: An Observer.
	mutating func remove(observer: Observer<Observation>) {
		observers.removeAll { $0 === observer }
	}

	/// Remove all observers.
	mutating func removeObservers() {
		observers.removeAll()
	}

	/// Send something observable to all observers.
	/// - Parameter observation: An Observation.
	func notifyObservers(_ observation: Observation) {
		for observer in observers {
			observer.observe(observation)
		}
	}
}
