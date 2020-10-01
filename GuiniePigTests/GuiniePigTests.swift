//
//  GuiniePigTests.swift
//  GuiniePigTests
//
//  Created by Balázs Szamódy on 25/9/20.
//  Copyright © 2020 Balázs Szamódy. All rights reserved.
//
import UIKit
import Configurable
import XCTest

final class FFConfigurableViewTests: XCTestCase {
    func testView() {
        let testView = TestView.fromNib()
        let data = TestItem()
        
        testView.configure(with: data)
        
        let expectedTitle = "Snatch"
        let expectedText = "You should never underestimate the predictability of stupidity."
        let expectedColor = UIColor.gray.withAlphaComponent(0.5)
        XCTAssertEqual(testView.titleLabel.text, expectedTitle)
        XCTAssertEqual(testView.textLabel.text, expectedText)
        XCTAssertEqual(testView.backgroundColor, expectedColor)
    }
    
    func testTableView() {
        let tableView = UITableView()
        tableView.register(type: TestView.self)
        
        let data = TestItem()
        
        let cell = tableView.dequeuReusableCell(forType: TestView.self, for: IndexPath(row: 0, section: 0))
        cell.configureContentView(TestView.self, with: data)
    }
    static var allTests = [
        ("testView", testView),
    ]
}

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

protocol TestDisplayable {
    var id: String { get }
    var testTitle: String? { get }
    var testText: String? { get }
    var testViewColor: UIColor? { get }
}

class TestView: UIView, Configurable {
    typealias Displayable = TestDisplayable
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    var data: TestDisplayable? {
        didSet {
            updateView()
        }
    }
    
    func configure(with displayable: Displayable) {
        data = displayable
    }
    
    private func updateView() {
        titleLabel.text = data?.testTitle
        textLabel.text = data?.testText
        self.backgroundColor = data?.testViewColor?.withAlphaComponent(0.5)
    }

}
