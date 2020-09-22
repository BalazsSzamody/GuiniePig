//
//  ViewState.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 22/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import Foundation

enum ViewState {
    case loading
    case failure(Error)
    case success
}
