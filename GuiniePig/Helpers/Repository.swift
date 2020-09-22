//
//  Repository.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 18/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import Foundation
import Combine

enum CustomHandledError: LocalizedError {
    case customError
    
    var errorDescription: String? {
        switch self {
        case .customError:
            return "Bad luck, please try again"
        }
    }
}

enum StandardError: LocalizedError {
    case standardError
    
    var errorDescription: String? {
        switch self {
        case .standardError:
            return "You need to pull after dismissing to refresh"
        }
    }
}

class Repository {
    var items = CurrentValueSubject<[TestItem], Never>([
        TestItem(),
        TestItem(title: "Snatch", text: """
                Do you know what "nemesis" means? A righteous infliction of retribution manifested by an appropriate agent. Personified in this case by an 'orrible cunt... me.
                """,
                 author: "Brick Top", color: .orange),
        TestItem(title: "Snatch", text: "Have you ever crossed the road, and looked the wrong way? A car's nearly on you? So what do you do? Something very silly. You freeze. Your life doesn't flash before you, 'cause you're too fuckin' scared to think - you just freeze and pull a stupid face. But the pikey didn't. Why? Because he had plans of running the car over.", author: "Turkish", color: .red),
    ])
    
    func refreshListItems() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.refresh(completion: { result in
                switch result {
                case .success(_):
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }
        .delay(for: 2, scheduler: DispatchQueue.global())
        .eraseToAnyPublisher()
    }
    
    private func refresh(completion: (Result<Void, Error>) -> Void) {
        let seed = Int.random(in: 0...6)
        switch seed {
        case 0...4:
            items.value = items.value.shuffled()
            completion(.success(()))
        case 5:
            completion(.failure(CustomHandledError.customError))
        case 6:
            completion(.failure(StandardError.standardError))
        default:
            break
        }
    }
}
