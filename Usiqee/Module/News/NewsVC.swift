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
    @IBOutlet weak private var loaderView: UIView!
    
    //MARK: - Properties
    private var tableViewHandler: NewsTableViewHandler = NewsTableViewHandler()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == NewsDetailsVC.Constants.identifier {
            guard let vc = segue.destination as? NewsDetailsVC,
                  let news = sender as? NewsItem else {
                return
            }
            
            vc.news = news
        }
    }
    
    // MARK: - Privates
    private func setupView() {
        syncNews()
        setupTableView()
        addLoadingFooter()
        loaderView.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func syncNews() {
        ManagerNews.shared.delegate = self
        ManagerNews.shared.setupListener()
    }
    
    private func setupTableView() {
        tableViewHandler.delegate = self
        tableView.register(NewsCell.Constants.nib,
                           forCellReuseIdentifier: NewsCell.Constants.identifier)
        tableView.register(NewsCarouselCell.Constants.nib,
                           forCellReuseIdentifier: NewsCarouselCell.Constants.identifier)
        tableView.register(NewsAdCell.Constants.nib,
                           forCellReuseIdentifier: NewsAdCell.Constants.identifier)
    }
    
    private func addLoadingFooter() {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }
    
    private func showLoadingFooter() {
        tableView.tableFooterView?.isHidden = false
    }
    
    private func hideLoaders() {
        tableView.tableFooterView?.isHidden = true
        loaderView.isHidden = true
    }
    
    private func showNewsDetails(_ news: NewsItem) {
        performSegue(withIdentifier: NewsDetailsVC.Constants.identifier, sender: news)
    }
}

// MARK: - UITableViewDataSource
extension NewsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        tableViewHandler.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHandler.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableViewHandler.heightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let item = tableViewHandler.item(for: indexPath) else {
            return UITableViewCell()
        }
        
        switch item {
        case let .carousel(news: news):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsCarouselCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsCarouselCell else { return UITableViewCell() }
            cell.configure(news: news, delegate: self)
            return cell
        case let .list(news: news):
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsCell else { return UITableViewCell() }
            cell.configure(item: news)
            return cell
        case .ad:
            let reusableCell = tableView.dequeueReusableCell(withIdentifier: NewsAdCell.Constants.identifier, for: indexPath)
            guard let cell = reusableCell as? NewsAdCell else { return UITableViewCell() }
            cell.configure()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHandler.willDisplayCell(at: indexPath)
    }
}

// MARK: - UITableViewDelegate
extension NewsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = tableViewHandler.item(for: indexPath) else { return }
        
        switch item {
        case let .list(news: news):
            showNewsDetails(news)
        default:
            break
        }
    }
}

// MARK: - ManagerNewsDelegate
extension NewsVC: ManagerNewsDelegate {
    func didUpdateNews() {
        tableViewHandler.allNews = ManagerNews.shared.allNews
        tableViewHandler.carouselNews = ManagerNews.shared.carouselNews
        tableView.reloadData()
        tableView.contentInset = tableViewHandler.contentInset
    }
    
    func didStartLoading() {
        loaderView.isHidden = false
    }
    
    func didFinishLoading() {
        hideLoaders()
    }
    
    func didLoadMore() {
        showLoadingFooter()
    }
}

// MARK: - NewsTableViewHandlerDelegate
extension NewsVC: NewsTableViewHandlerDelegate {
    func shouldLoadMore() {
        ManagerNews.shared.loadMore()
    }
}

// MARK: - NewsCarouselCellDelegate
extension NewsVC: NewsCarouselCellDelegate {
    func didSelectNews(at index: Int) {
        let news = ManagerNews.shared.carouselNews[index]
        showNewsDetails(news)
    }
}
