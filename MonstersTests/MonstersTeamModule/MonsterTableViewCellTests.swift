//
//  MonsterTableViewCellTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 23.01.2021.
//

import XCTest
@testable import Monsters

fileprivate class TableViewDataSource: NSObject, UITableViewDataSource {
    
    var items = [TeamedMonsterModel]()

    override init() {
        super.init()

        items = [TeamedMonsterModel(name: "Foo", imageName: "", level: 1)]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MonsterTableViewCell.reuseId,
        
                                                 for: indexPath) as! MonsterTableViewCell
        
        cell.setupCellFor(monster: items[indexPath.row])
        return cell
    }
}

fileprivate class TableViewDelegate: NSObject, UITableViewDelegate {
    
}

class MonsterTableViewCellTests: XCTestCase {
    
    var tableView: UITableView!
    private var dataSource: TableViewDataSource!
    private var delegate: TableViewDelegate!
    
    override func setUpWithError() throws {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 200, height: 400), style: .plain)
        let nib = UINib(nibName: MonsterTableViewCell.reuseId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MonsterTableViewCell.reuseId)
        
        dataSource = TableViewDataSource()
        delegate = TableViewDelegate()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    override func tearDownWithError() throws {
        tableView = nil
        dataSource = nil
        delegate = nil
    }
    
    func testSetupCellFor() {
        
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = createCell(indexPath: indexPath)
        XCTAssertEqual(cell.monsterLevelLabel.text, "Уровень: 1")
        XCTAssertEqual(cell.monsterNameLabel.text, "Foo")
    }
    
}

extension MonsterTableViewCellTests {
    
    func createCell(indexPath: IndexPath) -> MonsterTableViewCell {

        let cell = dataSource.tableView(tableView, cellForRowAt: indexPath) as! MonsterTableViewCell
        XCTAssertNotNil(cell)

        let view = cell.contentView
        XCTAssertNotNil(view)

        return cell
    }
}

