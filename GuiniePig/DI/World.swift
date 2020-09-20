//
//  World.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 18/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import Foundation
import NavHelper
#if DEBUG
var Current = World()
#else
let Current = World()
#endif

struct World {
    var listViewModel: () -> ListViewModel = {
        ListViewModelImp()
    }
    
    var detailViewModel: () -> DetailViewModel = {
        DetailViewModelImp()
    }
    
    var repository: Repository = Repository()
    
    var navHelper: NavHelper = NavHelperImp()
}
