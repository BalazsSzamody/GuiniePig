//
//  NavHelper.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import NavHelper

enum VCDetails: ViewControllerDetails {
    case mainNavigation
    case detail
    case addEdit
    
    var storyboard: String {
        switch self {
        case .mainNavigation,
             .detail,
             .addEdit:
            return "Main"
        }
    }
    
    var type: UIViewController.Type? {
        switch self {
        case .mainNavigation:
            return UINavigationController.self
        case .detail:
            return DetailViewController.self
        case .addEdit:
            return AddEditViewController.self
        }
    }
}

class NavHelperImp: NavHelper {
    var rootViewController: UIViewController?
}

extension UIViewController: NavHelperUsing {
    public var navHelper: NavHelper {
        Current.navHelper
    }
}
