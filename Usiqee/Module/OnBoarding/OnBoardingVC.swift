//
//  OnBoardingVC.swift
//  Usiqee
//
//  Created by Guaire94 on 28/09/2021.
//

import UIKit

class OnBoardingVC: UIViewController {
    
    // MARK: - Constant
    enum Constants {
        static let identifier: String = "OnBoardingVC"
        fileprivate static let externalLinkCornerRadius: CGFloat = 15
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var pageVCContainer: UIView!
    @IBOutlet weak private var nextButton: FilledButton!
    
    // MARK: - Properties
    var item: MOnBoardingItem?
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let item = self.item else { return }

        if segue.identifier == OnBoardingPageVC.Constants.identifier {
            guard let vc = segue.destination as? OnBoardingPageVC else { return }
            vc.item = item
        }
    }
    
    // MARK: - Privates
    private func setUpView() {
        nextButton.layer.cornerRadius = Constants.externalLinkCornerRadius
        nextButton.setTitle(L10N.OnBoarding.next, for: .normal)
    }
}

// MARK: - IBAction
private extension OnBoardingVC {
    
    @IBAction func startToggle(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
