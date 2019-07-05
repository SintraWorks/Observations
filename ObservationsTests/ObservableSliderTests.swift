//
//  ObservableSliderTests.swift
//  ObservationsTests
//
//  Created by Antonio Nunes on 02/06/2019.
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
import UIKit
@testable import Observations

class ObservableSliderTests: XCTestCase {

    var valueChangedCalled = false
    var isTrackingValue: Bool?

    func testSlider() {
        let slider = ObservableSlider()
        slider.addObserver(for: .allEvents) { [weak self] (action) in
            guard let self = self else { return }

            switch action {
            case .valueChanged:
                self.valueChangedCalled = true
            case .isTrackingTouch(let isTracking):
                self.isTrackingValue = isTracking
            }
        }

        slider.controlObserver.testBridge(with: .touchDown)
        guard let isTrackingValue1 = isTrackingValue else { return XCTFail("isTrackingTouch was not called")}
        XCTAssertTrue(isTrackingValue1, "isTrackingValue should be true")
        XCTAssertFalse(valueChangedCalled, "valueChangedCalled should be false")

        isTrackingValue = nil
        valueChangedCalled = false

        slider.controlObserver.testBridge(with: .valueChanged)
        XCTAssertTrue(valueChangedCalled, "valueChangedCalled should be true")
        guard isTrackingValue == nil else { return XCTFail("isTrackingTouch was called")}

        isTrackingValue = nil
        valueChangedCalled = false

        slider.controlObserver.testBridge(with: .touchUpInside)
        guard let isTrackingValue3 = isTrackingValue else { return XCTFail("isTrackingTouch was not called")}
        XCTAssertFalse(isTrackingValue3, "isTrackingValue should be false")
        XCTAssertFalse(valueChangedCalled, "valueChangedCalled should be false")

        isTrackingValue = nil
        valueChangedCalled = false

        // Test the default case which is a noOp
        slider.controlObserver.testBridge(with: .editingDidBegin)
        XCTAssertNil(isTrackingValue, "isTrackingValue should be nil")
        XCTAssertFalse(valueChangedCalled, "valueChangedCalled should be false")
    }
}
