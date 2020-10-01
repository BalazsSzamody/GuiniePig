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
        setupTableView()
        bindViewModel()
        updateViews()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(type: TestView.self)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        viewModel
            .viewState
            .sink(receiveValue: { [weak self] viewState in
                    self?.handleLoading(for: viewState)
                    switch viewState {
                    case .success:
                        self?.updateViews()
                    case let .failure(error as LocalizedError) :
                        self?.handleCustomError(error, completion: {
                            self?.viewModel.refresh()
                        })
                    default:
                        break
                    }
            })
            .store(in: &viewModel.disposeBag)
    }
    
    private func updateViews() {
        navigationItem.title = viewModel.title
        navigationItem.leftBarButtonItem?.title = viewModel.count
        tableView.reloadData()
    }
    
    private func handleLoading(for viewState: ViewState) {
        switch viewState {
        case .loading:
            tableView.refreshControl?.beginRefreshing()
            tableView.setContentOffset(
                CGPoint(x: 0,
                        y: -(tableView?
                            .refreshControl?
                            .frame
                            .height ?? 0)),
                animated: true)
        default:
            tableView.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func addDidTap(_ sender: Any) {
        navHelper
            .present(VCDetails.addEdit,
                     type: AddEditViewController.self,
                     over: self,
                     animated: true, beforeLoad: { (vc) in
                        vc.modalPresentationStyle = .fullScreen
                        vc.viewModel = Current.addEditViewModel(Current.repository)
                     },
                     completion: nil)
    }
    
    @objc private func refresh(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
            viewModel.refresh()
        }
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

extension UIViewController {
    func handleCustomError(_ error: LocalizedError, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            if error is CustomHandledError {
                completion?()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
