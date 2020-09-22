//
//  ViewModel.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 18/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Combine

protocol ListViewModel: ViewModelBase {
    var title: String? { get }
    var count: String? { get }
    var items: [TestDisplayable] { get }
    var customError: Error? { get }
    func prepareDetailVC(_ vc: DetailViewController, for indexPath: IndexPath)
    func refresh()
}

class ListViewModelImp: ViewModelBaseImp {
    // This can be abstracted if there are many Viewmodels and keep the view specific methods in extensions
    let repository: Repository
    private let viewUpdateTrigger = PassthroughSubject<Void, Never>()
    
    var items: [TestDisplayable] = []
    var customError: Error?
    
    init(repository: Repository = Current.repository) {
        self.repository = repository
        super.init()
        
        repository
            .items
            // This `map` is necessary to be able to use the abstract type of the model
            // We have to do our best to avoid using the concrete type in the ViewModel
            .map({ $0 })
            .sink(receiveValue: { [weak self] in
                self?.items = $0
                self?._viewState.value = .success
            })
            .store(in: &disposeBag)
    }
    
    override var errorFilter: (Error?) -> Bool {
        {
            $0 is StandardError }
    }
}

extension ListViewModelImp: ListViewModel {
    
    var viewUpdated: AnyPublisher<Void, Never> {
        viewUpdateTrigger
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var title: String? {
        "Quotes"
    }
    
    var count: String? {
        "\(items.count)"
    }
    
    func prepareDetailVC(_ vc: DetailViewController, for indexPath: IndexPath) {
        let viewModel = Current.detailViewModel()
        viewModel.setItemId(items[indexPath.row].id)
        vc.viewModel = viewModel
    }
    
    func refresh() {
        repository
            .refreshListItems()
            .filterError(filter: { [weak self] in
                !(self?.errorFilter($0) ?? true )
            })
            .handleViewState(in: self)
            .sink(receiveValue: {})
            .store(in: &disposeBag)
    }
}

