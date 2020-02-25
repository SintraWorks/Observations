//
//  ObservingTests.swift
//  ObservationsTests
//
//  Created by Antonio Nunes on 31/05/2019.
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

import XCTest
@testable import Observations

class ObservingTests: XCTestCase {

    func testObserverHandler() {
        let testValue = 42
        let intObserver = Observer<Int> { int in
            XCTAssertEqual(int, testValue, "incorrect value")
        }
        intObserver.observe(testValue)

        let testString = "Let it be"
        let stringObserver = Observer<String> { string in
            XCTAssertEqual(string, testString, "incorrect value")
        }
        stringObserver.observe(testString)

        let testNilOptional: Any? = nil
        let optionalObserver = Observer<Any?> { thing in
            XCTAssertNil(thing, "should be nil")
        }
        optionalObserver.observe(testNilOptional)

        let testNonNilOptional: UIColor? = UIColor.green
        let optionalObservable2 = Observer<UIColor?> { color in
            XCTAssertNotNil(color, "should not be nil")
        }
        optionalObservable2.observe(testNonNilOptional)

        var callbackCalled = false
        let voidObserver = Observer<Void> {
            callbackCalled = true
        }
        voidObserver.observe(())
        XCTAssertTrue(callbackCalled, "Callback for Void observer not called")
    }

	func testMultiObservable() {
		class MultiObservableTester: MultiObservable {
			typealias Observation = Void
			var observers: [Observer<Observation>] = []
		}

		var calledCount = 0

		let multiObservable = MultiObservableTester()

		let observer = multiObservable.addObserver { calledCount += 1 }

		XCTAssertTrue(multiObservable.observers.count == 1, "multiObservable should have 1 observer (has: \(multiObservable.observers.count)")

		multiObservable.notifyObservers(())
		XCTAssertTrue(calledCount == 1, "handler called \(calledCount) times (should be 1)")

		multiObservable.remove(observer: observer)
		XCTAssertTrue(multiObservable.observers.isEmpty, "multiObservable should be empty")

		multiObservable.addObserver { calledCount += 1 }
		multiObservable.addObserver {}
		XCTAssertTrue(multiObservable.observers.count == 2, "multiObservable should have 2 observers (has: \(multiObservable.observers.count)")

		multiObservable.add(observer: observer)
		XCTAssertTrue(multiObservable.observers.count == 3, "multiObservable should have 3 observers (has: \(multiObservable.observers.count)")

		calledCount = 0
		multiObservable.notifyObservers(())
		XCTAssertTrue(calledCount == 2, "handler called \(calledCount) times (should be 2)")

		multiObservable.removeObservers()
		XCTAssertTrue(multiObservable.observers.isEmpty, "multiObservable should be empty")
	}

}
