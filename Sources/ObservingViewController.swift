//
//  ObservingViewController.swift
//  Observations
//
//  Created by Antonio Nunes on 16/05/2019.
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

class ObservingViewController: UITableViewController {

    var tableViewNeedsSyncing = false

    var history = [String]() {
        didSet {
            tableViewNeedsSyncing = true
            if (self.navigationController?.visibleViewController == self) {
                reloadTableView()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (tableViewNeedsSyncing) {
            reloadTableView()
        }
    }
}

// MARK: - Navigation bar

extension ObservingViewController {
    @IBAction func showActions() {
        guard let vc = setupObservableViewController() else { return }
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func add(_ sender: Any) {
        history.append("\(history.count + 1) Local Action")
    }
    
    @IBAction func clear(_ sender: Any) {
        history.removeAll()
    }

    private func setupObservableViewController() -> UIViewController? {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ObservableViewController") as? ObservableViewController else { return nil }
        
        vc.observer = Observer<ObservableViewController.Action> { [weak self] (action) in
            guard let self = self else { return }

            switch action {
            case .button1Tapped:
                self.history.append("\(self.history.count + 1) Remote action on button 1")
            case .button2Tapped(let message):
                self.history.append("\(self.history.count + 1) " + message)
			case .sliderDragged(let newValue):
				self.history.append("\(self.history.count + 1) New value: \(newValue)")
			case .isTrackingSlider(let flag):
				self.history.append("\(self.history.count + 1) is tracking: \(flag)")
            }
        }

        return vc
    }
}

// MARK: - TableView

extension ObservingViewController {
    private func reloadTableView() {
        tableView.reloadData()
        tableViewNeedsSyncing = false
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = history[indexPath.row]

        return cell
    }
}
