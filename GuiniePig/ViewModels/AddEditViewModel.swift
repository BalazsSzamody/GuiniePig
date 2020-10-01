//
//  AddEditViewModel.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 21/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Combine

protocol AddEditViewModel: ViewModelBase {
    func addNewItem() -> AnyPublisher<Void, Never>
}

protocol AddEditRepository: AnyObject {
    func addNewItem(title: String?, text: String?, author: String, color: UIColor?) -> AnyPublisher<Bool, Error>
}

class AddEditViewModelImp: ViewModelBaseImp {
    let repository: AddEditRepository
    let title = "The Gentlemen"
    let text = "Make it quick. Make it funny."
    let author = "Coach"
    let color = UIColor.systemOrange
    
    init(repository: AddEditRepository) {
        self.repository = repository
    }
}

extension AddEditViewModelImp: AddEditViewModel {
    func addNewItem() -> AnyPublisher<Void, Never> {
        repository
            .addNewItem(title: title, text: text, author: author, color: color)
            .receive(on: DispatchQueue.main)
            .handleViewState(in: self, recoverWith: false)
            .filter({ $0 })
            .map({_ in return})
            .eraseToAnyPublisher()
    }
}

extension Repository: AddEditRepository {
    func addNewItem(title: String?, text: String?, author: String, color: UIColor?) -> AnyPublisher<Bool, Error> {
        Future<TestItem, Error> { promise in
            let random = Int.random(in: 0...1)
            if random == 0 {
                let item = TestItem(title: title, text: text, author: author, color: color)
                promise(.success((item)))
            } else {
                promise(.failure(CustomHandledError.customError))
            }
        }
        .delay(for: .seconds(1), scheduler: DispatchQueue.global())
        .map({[weak self] item in
            self?.items.value = self!.items.value + [ item ]
            return true
        })
        .eraseToAnyPublisher()
    }
}
