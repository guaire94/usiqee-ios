//
//  ForgetPasswordVC.swift
//  Usiqee
//
//  Created by Amine on 02/05/2021.
//

import UIKit
import Firebase

protocol ForgetPasswordVCDelegate: class {
    func didReset()
}

class ForgetPasswordVC: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak private var email: MTextField!
    @IBOutlet weak private var validButton: FilledButton!
    
    // MARK: - Variables
    weak var delegate: ForgetPasswordVCDelegate?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Privates
    private func setUpView() {
        setupEmailTextField()
        setupSignInButton()
    }
    
    private func setupEmailTextField() {
        email.delegate = self
        email.placeHolder = L10N.user.form.mail
        email.textContentType = .emailAddress
        email.returnKeyType = .send
    }
    
    private func setupSignInButton() {
        validButton.setTitle(L10N.ForgetPassword.form.valid, for: .normal)
        validButton?.titleLabel?.font = Fonts.ForgetPassword.valid
    }
}

// MARK: - IBAction
extension ForgetPasswordVC {

    @IBAction func dimissToggle() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func onResetToggle() {
        validButton.loadingIndicator(show: true)
        Auth.auth().sendPasswordReset(withEmail: email.text!) { [weak self] error in
            guard let self = self else { return }
            
            self.validButton.loadingIndicator(show: false)
            guard let error = error else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.showError(title: L10N.ForgetPassword.title, message: error.localizedDescription)
        }
    }
}

// MARK: - UITextFieldDelegate
extension ForgetPasswordVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onResetToggle()
        return true
    }
}
