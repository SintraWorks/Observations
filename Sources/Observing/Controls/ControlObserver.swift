//
//  ControlObserver.swift
//  Observing
//
//  Created by Antonio Nunes on 26/05/2019.
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

final internal class ControlObserver<Observation>: NSObject {
    internal class EventObserver {
        let observer: Observer<Observation>
        var controlEvents: UIControl.Event

        init(observer: Observer<Observation>, controlEvents: UIControl.Event) {
            self.observer = observer
            self.controlEvents = controlEvents
        }
    }

    private var bridge: ObjCSelectorBridge
	private weak var control: UIControl?
    internal var eventObservers = [EventObserver]()

    required init(with control: UIControl) {
        self.control = control
        self.bridge = ObjCSelectorBridge(with: control)
    }
}

// MARK: Observer management

extension ControlObserver {
    internal func addObserver(for controlEvents: UIControl.Event, handler: @escaping (Observation) -> Void) {
		guard let control = control else { return }
        let eventsAndSelectors = bridge.selectors(for: controlEvents)

        for (controlEvent, selector) in eventsAndSelectors {
            control.addTarget(bridge, action: selector, for: controlEvent)
        }

        let eventObserver = EventObserver(observer: Observer<Observation>(handler: handler), controlEvents: controlEvents)
        eventObservers.append(eventObserver)
    }

    internal func removeObservers(for controlEvents: UIControl.Event) {
        if controlEvents == .allEvents {
            eventObservers.removeAll()
            return
        }

        for event in controlEvents {
            // Remove all observers whose controlEvents match exactly
            eventObservers.removeAll(where: { $0.controlEvents.rawValue == event.rawValue })
            // For those that have more events, and can't be deleted yet, we remove the specific event.
            for eventObserver in eventObservers {
                if eventObserver.controlEvents.contains(event) {
                    eventObserver.controlEvents.remove(event)
                }
            }
        }

        control?.removeTarget(bridge, action: nil, for: controlEvents)
    }

    internal var observers: [Observer<Observation>] {
        return eventObservers.map({ $0.observer })
    }

    internal func observers(for controlEvents: UIControl.Event) -> [Observer<Observation>] {
        var observers = [Observer<Observation>]()

        for event in controlEvents {
            let filteredObservers = eventObservers.filter({ $0.controlEvents.contains(event) }).map({ $0.observer })
            observers.append(contentsOf: filteredObservers)
        }

        return observers
    }

    func actions(for controlEvent: UIControl.Event) -> [String]? {
        return control?.actions(forTarget: bridge, forControlEvent: controlEvent)
    }

    internal func testBridge(with controlEvents: UIControl.Event) {
        for controlEvent in controlEvents {
            switch controlEvent {
            case .touchDown:
                bridge.touchDown()
            case .touchDownRepeat:
                bridge.touchDownRepeat()
            case .touchDragInside:
                bridge.touchDragInside()
            case .touchDragOutside:
                bridge.touchDragOutside()
            case .touchDragEnter:
                bridge.touchDragEnter()
            case .touchDragExit:
                bridge.touchDragExit()
            case .touchUpInside:
                bridge.touchUpInside()
            case .touchUpOutside:
                bridge.touchUpOutside()
            case .touchCancel:
                bridge.touchCancel()
            case .valueChanged:
                bridge.valueChanged()
            case .primaryActionTriggered:
                bridge.primaryActionTriggered()
            case .editingDidBegin:
                bridge.editingDidBegin()
            case .editingChanged:
                bridge.editingChanged()
            case .editingDidEnd:
                bridge.editingDidEnd()
            case .editingDidEndOnExit:
                bridge.editingDidEndOnExit()
            default:
                break
            }
        }
    }
}

// MARK: - Objective-C bridge

@objc
final private class ObjCSelectorBridge: NSObject {
    private let control: UIControl

    private lazy var eventSelectors: [UIControl.Event.RawValue: Selector] = [
        UIControl.Event.touchDown.rawValue: #selector(touchDown),
        UIControl.Event.touchDownRepeat.rawValue: #selector(touchDownRepeat),
        UIControl.Event.touchDragInside.rawValue: #selector(touchDragInside),
        UIControl.Event.touchDragOutside.rawValue: #selector(touchDragOutside),
        UIControl.Event.touchDragEnter.rawValue: #selector(touchDragEnter),
        UIControl.Event.touchDragExit.rawValue: #selector(touchDragExit),
        UIControl.Event.touchUpInside.rawValue: #selector(touchUpInside),
        UIControl.Event.touchUpOutside.rawValue: #selector(touchUpOutside),
        UIControl.Event.touchCancel.rawValue: #selector(touchCancel),
        UIControl.Event.valueChanged.rawValue: #selector(valueChanged),
        UIControl.Event.primaryActionTriggered.rawValue: #selector(primaryActionTriggered),
        UIControl.Event.editingDidBegin.rawValue: #selector(editingDidBegin),
        UIControl.Event.editingChanged.rawValue: #selector(editingChanged),
        UIControl.Event.editingDidEnd.rawValue: #selector(editingDidEnd),
        UIControl.Event.editingDidEndOnExit.rawValue: #selector(editingDidEndOnExit)
    ]

    required init(with control: UIControl) {
        self.control = control
    }

    func selectors(for controlEvents: UIControl.Event) -> [(UIControl.Event, Selector)] {
        var selectors = [(UIControl.Event, Selector)]()
        for event in controlEvents {
            if let selector = eventSelectors[event.rawValue] {
                selectors.append((event, selector))
            }
        }

        return selectors
    }
}

extension ObjCSelectorBridge {
    @objc fileprivate func touchDown() {
        control.sendActions(for: .touchDown)
    }

    @objc fileprivate func touchDownRepeat() {
        control.sendActions(for: .touchDownRepeat)
    }

    @objc fileprivate func touchDragInside() {
        control.sendActions(for: .touchDragInside)
    }

    @objc fileprivate func touchDragOutside() {
        control.sendActions(for: .touchDragOutside)
    }

    @objc fileprivate func touchDragEnter() {
        control.sendActions(for: .touchDragEnter)
    }

    @objc fileprivate func touchDragExit() {
        control.sendActions(for: .touchDragExit)
    }

    @objc fileprivate func touchUpInside() {
        control.sendActions(for: .touchUpInside)
    }

    @objc fileprivate func touchUpOutside() {
        control.sendActions(for: .touchUpOutside)
    }

    @objc fileprivate func touchCancel() {
        control.sendActions(for: .touchCancel)
    }

    @objc fileprivate func valueChanged() {
        control.sendActions(for: .valueChanged)
    }

    @objc fileprivate func primaryActionTriggered() {
        control.sendActions(for: .primaryActionTriggered)
    }

    @objc fileprivate func editingDidBegin() {
        control.sendActions(for: .editingDidBegin)
    }

    @objc fileprivate func editingChanged() {
        control.sendActions(for: .editingChanged)
    }

    @objc fileprivate func editingDidEnd() {
        control.sendActions(for: .editingDidEnd)
    }

    @objc fileprivate func editingDidEndOnExit() {
        control.sendActions(for: .editingDidEndOnExit)
    }
}

// MARK: - Iterating over UIControl.Event

extension UIControl.Event: Sequence {
    public __consuming func makeIterator() -> OptionSetIterator<UIControl.Event> {
        return OptionSetIterator(element: self)
    }
}
