//
//  OnBoardingPageVC.swift
//  Usiqee
//
//  Created by Guaire94 on 28/09/2021.
//

import UIKit

class OnBoardingPageVC: UIPageViewController {
    
    // MARK: - Constants
    enum Constants {
        static let identifier = "OnBoardingPageVC"
    }

    // MARK: - Properties
    var item: MOnBoardingItem?
    private var items: [UIViewController] = []
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        decoratePageControl()
        
        populateItems()
        if let firstViewController = items.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Privates
    private func decoratePageControl() {
        let pc = UIPageControl.appearance(whenContainedInInstancesOf: [OnBoardingPageVC.self])
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = .gray
    }
    
    private func populateItems() {
        guard let item = self.item else { return }
        for viewModel in item.viewModels {
            let vc = UIViewController()
            vc.view = OnBoardingView(title: viewModel.title, description: viewModel.description)
            items.append(vc)
        }
    }
}

// MARK: - DataSource
extension OnBoardingPageVC: UIPageViewControllerDataSource {
    
    func presentationCount(for _: UIPageViewController) -> Int {
        items.count
    }
    
    func presentationIndex(for _: UIPageViewController) -> Int {
        guard let firstVC = viewControllers?.first, let index = items.firstIndex(of: firstVC) else { return .zero }
        return index
    }
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        guard previousIndex >= .zero else { return nil }
        
        return items[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = items.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        guard nextIndex < items.count else { return nil }
        
        return items[nextIndex]
    }
}
