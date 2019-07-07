Observations
====

A light-weight implementation of Observables, Including a trivial example project for iOS and 100% (but not exhaustive) test coverage.

Usage
====

To make an object observable, make it conform to the Observable protocol:

    class ObservableViewController: UIViewController, Observable {
        enum Action {
            case button1Tapped
            case button2Tapped(message: String)
        }

        typealias Observation = Action

        var observer: Observer<Observation>?
    	…
    }


To create an observer for the observable:

    observer = Observer<ObservableViewController.Action> { [weak self] (action) in
                guard let self = self else { return }

                switch action {
                case .button1Tapped:
                    self.history.append("\(self.history.count + 1) Remote action on button 1")
                case .button2Tapped(let message):
                    self.history.append("\(self.history.count + 1) " + message)
                }
            }

For more info, see [this blog post](https://sintraworks.github.io/swift/2019-07-07-observables-1).
