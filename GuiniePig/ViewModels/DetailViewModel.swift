//
//  DetailViewModel.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Combine

protocol DetailViewModel: ViewModelBase {
    var detailItem: DetailViewDisplayable? { get }
    var viewUpdated: AnyPublisher<Void, Never> { get }
    func setItemId(_ id: String)
}

protocol DetailViewDisplayable {
    var detailTitle: String? { get }
    var detailQuote: String? { get }
    var detailAuthor: String? { get }
    var detailBGColor: UIColor? { get }
}

class DetailViewModelImp: ViewModelBaseImp {
    let repository: DetailRepository
    private var itemId: String?
    private(set) var detailItem: DetailViewDisplayable?
    
    let viewUpdateTrigger = PassthroughSubject<Void, Never>()
    
    init(repository: Repository = Current.repository) {
        self.repository = DetailRepository(repository)
        super.init()
        
        self.repository
            .selectedItem
            .sink { [weak self] (item) in
                self?.detailItem = item
            }
            .store(in: &disposeBag)
            
    }
}

extension DetailViewModelImp: DetailViewModel {
    var viewUpdated: AnyPublisher<Void, Never> {
        return viewUpdateTrigger
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setItemId(_ id: String) {
        repository.selectedItemId.value = id
    }
}

class DetailRepository {
    let globalRepository: Repository
    
    let selectedItemId = CurrentValueSubject<String?, Never>(nil)
    
    var selectedItem: AnyPublisher<TestItem, Never> {
        let items: AnyPublisher<[TestItem], Never> = globalRepository
            .items
            .catch { (_) -> AnyPublisher<[TestItem], Never> in
                Just([])
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
            
        
        return items
            .combineLatest(selectedItemId)
            .compactMap { (items, itemId) -> TestItem? in
                items.first(where: { $0.id == itemId })
            }
            .eraseToAnyPublisher()
    }
    
    init(_ repository: Repository) {
        self.globalRepository = repository
    }
}

extension TestItem: DetailViewDisplayable {
    var detailTitle: String? {
        title
    }
    
    var detailQuote: String? {
        text
    }
    
    var detailAuthor: String? {
        author
    }
    
    var detailBGColor: UIColor? {
        color
    }
    
    
}
