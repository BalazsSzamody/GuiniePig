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
    var viewState: AnyPublisher<ViewState, Never> { get }
    var disposeBag: DisposeBag { get set }
}

class ViewModelBaseImp: ViewModelBase {
    var disposeBag = DisposeBag()
    
    let _viewState = CurrentValueSubject<ViewState, Never>(.success)
    
    var viewState: AnyPublisher<ViewState, Never> {
        _viewState
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    // Override this for error filtering
    var errorFilter: (Error?) -> Bool {
        { _ in
            return true
        }
    }
    
    init() {
        viewState
            .compactMap({
                guard case let .failure(error) = $0 else {
                    return nil
                }
                return error
            })
            .filter(errorFilter)
            .compactMap({ $0 })
            .eraseToAnyPublisher()
//            .subscribe(on: DispatchQueue.main)
            .sink(receiveValue: {
                let alert = UIAlertController(title: "Error", message: $0.localizedDescription, preferredStyle: .alert)
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
