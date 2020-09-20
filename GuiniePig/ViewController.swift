//
//  ViewController.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/3/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var viewModel: ViewModel!
    
    @IBOutlet weak var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = Current.viewModel()
        updateViews()
    }
    
    private func updateViews() {
        verticalStackView
            .removeAllArrangedSubviews()
        
        viewModel
            .items
            .enumerated()
            .forEach({
                let odd = $0.0 % 2 == 0
                if odd {
                    verticalStackView
                        .addArrangedSubview(UIStackView.stockStack())
                }
                guard let horizontalStack = verticalStackView.arrangedSubviews.last as? UIStackView else {
                    return
                }
                let testView = TestView.fromNib()
                testView.data = $0.1
                testView.delegate = self
                let tap = UITapGestureRecognizer(target: self, action: #selector({
                    
                }))
                horizontalStack.addArrangedSubview(testView)
            })
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }


}

extension ListViewController: TestViewDelegate {
    
}

fileprivate extension UIStackView {
    static func stockStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        return stack
    }
    
    func removeAllArrangedSubviews() {
        arrangedSubviews
            .forEach({
                $0.removeFromSuperview()
            })
    }
}
