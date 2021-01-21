//
//  MonsterTeamViewController.swift
//  Monsters
//
//  Created by Maxim Alekseev on 20.01.2021.
//

import UIKit

//MARK: - Monster Team View Protocol

protocol MonsterTeamViewProtocol: class {
    
    var presenter: MonsterTeamPresenterProtocol? { get set }
    
}

//MARK: - Monster Team View Controller class

class MonsterTeamViewController: UIViewController {
    
    //MARK: - Class properties
    
    var presenter: MonsterTeamPresenterProtocol?
        
    //IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
            }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()

    }

    deinit {
        print(String(describing: MonsterTeamViewController.self) + " deinit")
    }
    
    //MARK:- Methods
    
    private func setupTableView() {
        let nib = UINib(nibName: MonsterTableViewCell.reuseId, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: MonsterTableViewCell.reuseId)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Моя команда"
    }
}


//MARK: - Monster Team View Protocol extension

extension MonsterTeamViewController: MonsterTeamViewProtocol {
    
}

//MARK: - Table View Data source, Delegate

extension MonsterTeamViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.monstersTeam.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MonsterTableViewCell.reuseId, for: indexPath) as! MonsterTableViewCell
        let monster = presenter?.monstersTeam[indexPath.row]
        cell.setupCellFor(monster: monster)
        return cell
    }
    
    
}
