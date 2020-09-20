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
    var viewUpdated: AnyPublisher<Void, Never> { get }
    var title: String? { get }
    var count: String? { get }
    var items: [TestDisplayable] { get }
    func prepareDetailVC(_ vc: DetailViewController, for indexPath: IndexPath)
}

class ListViewModelImp: ViewModelBaseImp {
    // This can be abstracted if there are many Viewmodels and keep the view specific methods in extensions
    let repository: Repository
    private let viewUpdateTrigger = PassthroughSubject<Void, Never>()
    
    var items: [TestDisplayable] = []
    
    init(repository: Repository = Current.repository) {
        self.repository = repository
        super.init()
        
        repository
            .items
            // This `map` is necessary to be able to use the abstract type of the model
            // We have to do our best to avoid using the concrete type in the ViewModel
            .map({ $0 })
            .catch {[weak self] (error) -> AnyPublisher<[TestDisplayable], Never> in
                self?._error.value = error
                return Just([])
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] in
                self?.items = $0
            })
            .store(in: &disposeBag)
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
}
