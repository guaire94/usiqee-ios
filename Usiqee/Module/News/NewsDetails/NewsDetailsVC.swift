//
//  NewsDetailsVC.swift
//  Usiqee
//
//  Created by Amine on 06/07/2021.
//

import UIKit
import SafariServices

class NewsDetailsVC: UIViewController {

    // MARK: - Constants
    enum Constants {
        static let identifier: String = "NewsDetailsVC"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var loaderView: UIView!
    
    // MARK: - Properties
    private var tableViewHandler: NewsDetailsTableViewHandler = NewsDetailsTableViewHandler()
    var news: NewsItem?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private
    private func setupView() {
        syncNewsDetails()
        setupTableView()
    }
    
    private func syncNewsDetails() {
        loaderView.isHidden = false
        guard let news = news else { return }
        ServiceNews.syncAllInformation(news: news) { [weak self] sections, author in
            guard let self = self else { return }
            self.tableViewHandler.sections = sections
            self.tableViewHandler.author = author
            self.tableView.reloadData()
            self.loaderView.isHidden = true
        }
    }
    
    private func setupTableView() {
        tableViewHandler.news = news
        tableView.register(NewsDetailsOverviewCell.Constants.nib, forCellReuseIdentifier: NewsDetailsOverviewCell.Constants.identifier)
        tableView.register(NewsDetailsTextCell.Constants.nib, forCellReuseIdentifier: NewsDetailsTextCell.Constants.identifier)
        tableView.register(NewsDetailsImageCell.Constants.nib, forCellReuseIdentifier: NewsDetailsImageCell.Constants.identifier)
        tableView.register(NewsDetailsAuthorCell.Constants.nib, forCellReuseIdentifier: NewsDetailsAuthorCell.Constants.identifier)
        tableView.register(NewsDetailsVideoCell.Constants.nib, forCellReuseIdentifier: NewsDetailsVideoCell.Constants.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = nil
    }
}

// MARK: - UITableViewDataSource
extension NewsDetailsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHandler.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = tableViewHandler.item(for: indexPath) else {
            return UITableViewCell()
        }
        
        switch item {
        case let .overview(news):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsDetailsOverviewCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsDetailsOverviewCell else { return UITableViewCell() }
            cell.configure(item: news)
            return cell
        case let .image(url):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsDetailsImageCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsDetailsImageCell else { return UITableViewCell() }
            cell.configure(url: url)
            return cell
        case let .text(content):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsDetailsTextCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsDetailsTextCell else { return UITableViewCell() }
            cell.configure(content: content)
            return cell
        case let .author(author):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsDetailsAuthorCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsDetailsAuthorCell else { return UITableViewCell() }
            cell.configure(author: author, delegate: self)
            return cell
        case let .video(videoId):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsDetailsVideoCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsDetailsVideoCell else { return UITableViewCell() }
            cell.configure(videoId: videoId)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension NewsDetailsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewHandler.heightForRow(at: indexPath)
    }
}

// MARK: - IBActions
private extension NewsDetailsVC {
    @IBAction func onBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - NewsDetailsAuthorCellDelegate

extension NewsDetailsVC: NewsDetailsAuthorCellDelegate {
    func openExternalLink(url: String?) {
        guard let urlString = url,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showExternalLink(url: String?) {
        guard let urlString = url,
              let url = URL(string: urlString),
              UIApplication.shared.canOpenURL(url) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        
        let vc = SFSafariViewController(url: url, configuration: config)
        if #available(iOS 13.0, *) {
            vc.modalPresentationStyle = .automatic
        }
        present(vc, animated: true)
    }
}
