//
//  ViewModelBase.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Combine

typealias DisposeBag = Set<AnyCancellable>

protocol ViewModelBase: AnyObject {
    var disposeBag: DisposeBag { get set }
    var isLoading: AnyPublisher<Bool, Never> { get }
    var error: AnyPublisher<Error?, Never> { get }
}

class ViewModelBaseImp: ViewModelBase {
    var disposeBag = DisposeBag()
    
    let _isLoading = CurrentValueSubject<Bool, Never>(false)
    let _error = CurrentValueSubject<Error?, Never>(nil)
    
    var isLoading: AnyPublisher<Bool, Never> {
        _isLoading
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<Error?, Never> {
        _error
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Override this for error filtering
    var errorFilter: (Error?) -> Bool = { _ in
        return true
    }
    
    init() {
        error
            .filter({ $0 != nil })
            .filter(errorFilter)
            .sink(receiveValue: {
                let alert = UIAlertController(title: "Error", message: $0?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                UIApplication
                    .shared
                    .connectedScenes
                    .lazy
                    .filter({ $0.activationState == .foregroundActive })
                    .compactMap({ $0 as? UIWindowScene })
                    .first?
                    .windows
                    .first(where: { $0.isKeyWindow})?
                    .rootViewController?
                    .present(alert, animated: true, completion: nil)
            })
            .store(in: &disposeBag)
    }
}
