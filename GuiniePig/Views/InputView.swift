//
//  InputView.swift
//  GuiniePig
//
//  Created by Balázs Szamódy on 21/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//

import UIKit
import Configurable

protocol InputViewDisplayable {
    var inputTitle: String { get }
    var inputText: String? { get }
}

protocol InputDelegate: AnyObject {
    func valueChanged(in view: InputView, newValue: String?)
}

class InputView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var data: InputViewDisplayable?
    
    weak var delegate: InputDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldValueDidChange(_:)), for: .editingChanged)
    }
    
    private func updateView() {
        
    }
    
    @objc private func textFieldValueDidChange(_ sender: UITextField) {
        delegate?.valueChanged(in: self, newValue: sender.text)
    }
}

extension InputView: Configurable {
    typealias Displayable = InputViewDisplayable
    
    func configure(with displayable: Displayable) {
        data = displayable
    }
}
