//
//  ControlObserverTests.swift
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

import XCTest
@testable import Observations

private final class TestControl: UIControl, ObservableControl {
    typealias Observed = Void

    lazy internal var controlObserver = ControlObserver<Observed>(with: self)

    override func sendActions(for controlEvents: UIControl.Event) {
        for event in controlEvents {
            for eventObserver in controlObserver.eventObservers {
                if eventObserver.controlEvents.contains(event) {
                    eventObserver.observer.observe(())
                }
            }
        }
    }
}

class ControlObserverTests: XCTestCase {

    fileprivate var control: TestControl!

    override func setUp() {
        control = TestControl()
    }

    func testAllEvents() {
        var counter = 0

        control.addObserver(for: .allEvents) {
            counter += 1
        }

        XCTAssertEqual(control.controlObserver.observers.count, 1, "Only one observer should have been created (is: \(counter))")

        guard let actions1 = control.actions(for: .touchDown) else { return XCTFail("nil actions returned") }
        XCTAssertEqual(actions1.count, 1, "Should have one action (have: \(actions1.count))")
        XCTAssertEqual(actions1.first!, "touchDown", "Action sould be \"touchDown\" (have: \(actions1.first!))")

        guard let actions2 = control.actions(for: .touchCancel) else { return XCTFail("nil actions returned") }
        XCTAssertEqual(actions2.count, 1, "Should have one action (have: \(actions2.count))")
        XCTAssertEqual(actions2.first!, "touchCancel", "Action sould be \"touchCancel\" (have: \(actions2.first!))")

        control.controlObserver.testBridge(with: .allEvents)
        XCTAssertEqual(counter, 15, "Counter should be 15, is \(counter)")

        control.controlObserver.testBridge(with: .primaryActionTriggered)
        XCTAssertEqual(counter, 16, "Counter should be 16, is \(counter)")

        control.removeObservers(for: .editingChanged)
        XCTAssertEqual(control.controlObserver.observers.count, 1, "No observers should have been removed (have: \(counter))")

        control.removeObservers(for: .editingDidEndOnExit)
        let remainingEvents = control.allControlEvents
        XCTAssertEqual(remainingEvents, [
            .touchDown, .touchDownRepeat,
            .touchDragInside, .touchDragOutside, .touchDragEnter, .touchDragExit,
            .touchUpInside, .touchUpOutside, .touchCancel,
            .valueChanged, .primaryActionTriggered,
            .editingDidBegin, .editingDidEnd
            ], "Incorrect set of control events.")

        var observers = control.observers
        XCTAssertEqual(observers.count, 1, "Incorrect number of observers (should be 1, have: \(observers.count)")

        observers = control.observers(for: .editingDidEndOnExit)
        XCTAssertEqual(observers.count, 0, "Incorrect number of observers (should be 0, have: \(observers.count)")

        observers = control.observers(for: .primaryActionTriggered)
        XCTAssertEqual(observers.count, 1, "Incorrect number of observers (should be 1, have: \(observers.count)")

        observers = control.observers(for: [.primaryActionTriggered, .editingDidBegin, .editingDidEndOnExit])
        XCTAssertEqual(observers.count, 2, "Incorrect number of observers (should be 2, have: \(observers.count)")
    }

    func testSomeEvents() {
        var counter = 0
        var counterBis = 0

        control.addObserver(for: .touchUpInside) {
            counter += 1
        }

        var observers = control.controlObserver.observers(for: .touchUpInside)
        XCTAssertEqual(observers.count, 1, "There should be 1 observer, (have: \(counter))")

        control.controlObserver.testBridge(with: .touchUpInside)
        XCTAssertEqual(counter, 1, "Counter should be 1, is \(counter)")
        control.controlObserver.testBridge(with: .touchUpOutside)
        XCTAssertEqual(counter, 1, "Counter should be 1, is \(counter)")

        control.addObserver(for: .touchUpInside) {
            counterBis += 1
        }

        observers = control.observers(for: .touchUpInside)
        XCTAssertEqual(observers.count, 2, "There should be 2 observers, (have: \(counter))")
        observers = control.observers(for: .touchUpOutside)
        XCTAssertEqual(observers.count, 0, "There should be 0 observers, (have: \(counter))")

        control.controlObserver.testBridge(with: .touchUpInside)
        XCTAssertEqual(counter, 2, "Counter should be 2, is \(counter)")
        XCTAssertEqual(counterBis, 1, "CounterBis should be 1, is \(counter)")

        control.addObserver(for: .touchUpOutside) {
            counterBis += 1
        }

        observers = control.observers(for: .touchUpOutside)
        XCTAssertEqual(observers.count, 1, "There should be 1 observer, (have: \(counter))")
        
        control.removeObservers(for: .touchUpOutside)
        observers = control.observers(for: .touchUpOutside)
        XCTAssertEqual(observers.count, 0, "There should be 0 observers, (have: \(counter))")

        control.removeObservers(for: .allEvents)
        XCTAssertEqual(control.controlObserver.observers.count, 0, "All observers should have been removed (have: \(counter))")

        observers = control.observers(for: .touchUpInside)
        XCTAssertEqual(observers.count, 0, "There should be 0 observers, (have: \(counter))")
        observers = control.observers(for: .allEvents)
        XCTAssertEqual(observers.count, 0, "There should be 0 observers, (have: \(counter))")
    }
}
