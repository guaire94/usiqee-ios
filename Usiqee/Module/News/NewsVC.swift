//
//  AgendaVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 10/11/2020.
//

import UIKit
import Firebase

class NewsVC: UIViewController {
    
    //MARK: - Constant
    enum Constants {
        static let identifier = "NewsVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    
    //MARK: - Properties
    var news: [News] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        syncNews()
    }
    
    func syncNews() {
    }

    // MARK: - Privates
    private func setUpView() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: NewsCell.Constants.identifier, bundle: nil),
                           forCellReuseIdentifier: NewsCell.Constants.identifier)
    }
}

// MARK: - UITableViewDataSource
extension NewsVC: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        NewsCell.Constants.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.Constants.identifier, for: indexPath)
        guard let cell = reusableCell as? NewsCell else { return UITableViewCell() }
        let new = news[indexPath.row]
        cell.setUp(new: new)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
