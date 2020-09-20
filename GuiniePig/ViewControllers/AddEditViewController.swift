//
//  AddEditViewController.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 21/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController {
    var viewModel: AddEditViewModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveDidTap(_ sender: Any) {
    }
    @IBAction func cancelDidTap(_ sender: Any) {
    }
    
}
