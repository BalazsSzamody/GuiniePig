//
//  Publisher+ViewState.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 22/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func handleError<T>(in viewModel: T, recoverWith value: Self.Output) -> AnyPublisher<Self.Output, Never> where T: ViewModelBaseImp {
        self.catch({ [weak viewModel] (error) -> Just<Self.Output> in
            viewModel?._viewState.value = .failure(error)
            return Just(value)
        }).eraseToAnyPublisher()
    }
    
    func handleLoading<T>(in viewModel: T) -> AnyPublisher<Self.Output, Self.Failure> where T: ViewModelBaseImp {
        viewModel._viewState.value = .loading
        return self.eraseToAnyPublisher()
    }
    
    func handleViewState<T>(in viewModel: T, recoverWith value: Self.Output) -> AnyPublisher<Self.Output, Never> where T: ViewModelBaseImp {
        self
            .handleLoading(in: viewModel)
            .handleError(in: viewModel, recoverWith: value)
            .handleSuccess(in: viewModel)
    }
    
    func handleSuccess<T>(in viewModel: T) -> AnyPublisher<Self.Output, Self.Failure> where T: ViewModelBaseImp {
        self.handleEvents(receiveOutput: {[weak viewModel] _ in
            viewModel?._viewState.value = .success
        })
        .eraseToAnyPublisher()
    }
    
    func filterError(filter closure: @escaping (Failure) -> Bool, recoverWith value: Output) -> AnyPublisher<Output, Failure> {
        self.catch { (error) -> AnyPublisher<Output, Failure> in
            guard closure(error) else {
                return Result.Publisher(value)
                    .eraseToAnyPublisher()
            }

            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    
    func toTrigger() -> AnyPublisher<Void, Failure> {
        self.map({ _ in return })
            .eraseToAnyPublisher()
    }
}

extension Publisher where Output == Void {
    func handleViewState<T>(in viewModel: T) -> AnyPublisher<Self.Output, Never> where T: ViewModelBaseImp {
        handleViewState(in: viewModel, recoverWith: ())
    }
    
    func filterError(filter closure: @escaping (Failure) -> Bool) -> AnyPublisher<Output, Failure> {
        filterError(filter: closure, recoverWith: ())
    }
}
