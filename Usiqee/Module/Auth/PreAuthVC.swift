//
//  PreAuthVC.swift
//  Usiqee
//
//  Created by Amine on 01/05/2021.
//

import UIKit

protocol PreAuthVCDelegate: class {
    func didSignIn()
}

class PreAuthVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak private var signUpButton: FilledButton!
    @IBOutlet weak private var singInButton: UIButton!
    @IBOutlet weak private var separatorLabel: UILabel!
    
    // MARK: - Variables
    weak var delegate: PreAuthVCDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SignInVC.Constants.identifier {
            guard let signInVC = segue.destination as? SignInVC else {
                return
            }
            
            signInVC.delegate = self
        } else if segue.identifier == SignUpVC.Constants.identifier {
            guard let signUpVC = segue.destination as? SignUpVC else {
                return
            }
            
            signUpVC.delegate = self
        }
    }
    
    // MARK: - Private
    private func setupView() {
        setupSignInButton()
        setupSignUpButton()
        setupSeparator()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupSeparator() {
        separatorLabel.font = Fonts.PreAuth.separator
        separatorLabel.text = L10N.preAuth.separator
    }
    
    private func setupSignInButton() {
        signUpButton.layer.cornerRadius = 25
        signUpButton?.titleLabel?.font = Fonts.PreAuth.signUp
        signUpButton.setTitle(L10N.preAuth.signUp, for: .normal)
    }
    
    private func setupSignUpButton() {
        singInButton.layer.cornerRadius = 5
        singInButton.clipsToBounds = true
        singInButton.setBackgroundColor(Colors.gray.withAlphaComponent(0.7))
        singInButton?.titleLabel?.font = Fonts.PreAuth.signIn
        singInButton.setTitle(L10N.preAuth.signIn, for: .normal)
    }
}

// MARK: - IBActions
extension PreAuthVC {
    @IBAction func onDismissToggle() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - SignInVCDelegate
extension PreAuthVC: SignInVCDelegate {
    func didSignIn() {
        dismiss(animated: true, completion: nil)
        delegate?.didSignIn()
    }
}

// MARK: - SignUpVCDelegate
extension PreAuthVC: SignUpVCDelegate {
    func didSignUp() {
        dismiss(animated: true, completion: nil)
        delegate?.didSignIn()
    }
}
