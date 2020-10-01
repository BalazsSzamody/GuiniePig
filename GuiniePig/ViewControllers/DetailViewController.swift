//
//  DetailViewController.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var viewModel: DetailViewModel!

    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel
            .viewUpdated
            .sink(receiveValue: { [weak self] in
                self?.updateViews()
            })
            .store(in: &viewModel.disposeBag)
        
        updateViews()
    }
    
    private func updateViews() {
        navigationItem.title = viewModel.detailItem?.detailTitle
        quoteLabel.text = viewModel.detailItem?.detailQuote
        authorLabel.text = viewModel.detailItem?.detailAuthor
    }

    @IBAction func editDidTap(_ sender: Any) {
        
    }
}
