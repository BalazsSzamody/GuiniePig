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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .viewState
            .sink(receiveValue: {[weak self] state in
                self?.handleLoading(for: state)
                switch state {
                case .success,
                     .loading:
                    break
                case .failure(let error):
                    if let error = error as? CustomHandledError {
                        self?.handleCustomError(error)
                    }
                    break
                }
            })
            .store(in: &viewModel.disposeBag)
        
        
    }
    
    private func handleLoading(for state: ViewState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            saveButton.isEnabled = false
        default:
            activityIndicator.stopAnimating()
            saveButton.isEnabled = true
        }
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
        viewModel
            .addNewItem()
            .sink(receiveValue: { [weak self] in
                self?.dismiss()
            })
            .store(in: &viewModel.disposeBag)
    }
    @IBAction func cancelDidTap(_ sender: Any) {
        dismiss()
    }
    
}
