//
//  ObservableControl.swift
//  Observations
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

import UIKit

protocol ObservableControl {
    associatedtype Observation

    var controlObserver: ControlObserver<Observation> { get }

    func addObserver(for controlEvents: UIControl.Event, handler: @escaping (Observation) -> Void)
    func removeObservers(for controlEvents: UIControl.Event)

    func sendActions(for controlEvents: UIControl.Event)

    func actions(for controlEvents: UIControl.Event) -> [String]?
    func observers(for controlEvents: UIControl.Event) -> [Observer<Observation>]
    var observers: [Observer<Observation>] { get }
}

extension ObservableControl {
    func addObserver(for controlEvents: UIControl.Event, handler: @escaping (Observation) -> Void) {
        controlObserver.addObserver(for: controlEvents, handler: handler)
    }

    func removeObservers(for controlEvents: UIControl.Event) {
        controlObserver.removeObservers(for: controlEvents)
    }

    func observers(for controlEvents: UIControl.Event) -> [Observer<Observation>] {
        return controlObserver.observers(for: controlEvents)
    }

    var observers: [Observer<Observation>] {
        return controlObserver.observers
    }

    func actions(for controlEvent: UIControl.Event) -> [String]? {
        return controlObserver.actions(for: controlEvent)
    }
}
