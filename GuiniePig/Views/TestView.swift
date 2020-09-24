//
//  TestView.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 20/3/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Configurable

struct TestItem: Identifiable {
    var id: String = UUID().uuidString
    var title: String? = "Snatch"
    var text: String? = "You should never underestimate the predictability of stupidity."
    var author: String = "Bullet Tooth Tony"
    var color: UIColor? = .gray
}

extension TestItem: TestDisplayable {
    var testTitle: String? {
        title
    }
    
    var testText: String? {
        text
    }
    
    var testViewColor: UIColor? {
        color
    }
}

protocol TestDisplayable: Displayable {
    var id: String { get }
    var testTitle: String? { get }
    var testText: String? { get }
    var testViewColor: UIColor? { get }
}

protocol TestViewDelegate: AnyObject {
    
}

class TestView: UIView, Configurable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
        
    weak var delegate: TestViewDelegate?
    
    var data: TestDisplayable? {
        didSet {
            updateView()
        }
    }
    
    var isDisabled: Bool = false {
        didSet {
            updateView()
        }
    }
    
    func configure(with displayable: Displayable) {
        guard let displayable = displayable as? TestDisplayable else {
            preconditionFailure("Use the correct displayable: TestDisplayable")
        }
        
        data = displayable
    }
    
    private func updateView() {
        titleLabel.text = data?.testTitle
        textLabel.text = data?.testText
        self.backgroundColor = data?.testViewColor?.withAlphaComponent(0.5)
    }

}
