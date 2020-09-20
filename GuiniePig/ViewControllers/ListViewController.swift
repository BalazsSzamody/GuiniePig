//
//  ViewController.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/3/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var viewModel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = Current.listViewModel()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(type: TestView.self)
        updateViews()
    }
    
    private func updateViews() {
        navigationItem.title = viewModel.title
        navigationItem.leftBarButtonItem?.title = viewModel.count
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeuReusableCell(forType: TestView.self, for: indexPath)
        cell.configureContentView(TestView.self, with: viewModel.items[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        show(VCDetails.detail, type: DetailViewController.self, beforeLoad: { [weak self] vc in
            self?.viewModel.prepareDetailVC(vc, for: indexPath)
        })
    }
}
