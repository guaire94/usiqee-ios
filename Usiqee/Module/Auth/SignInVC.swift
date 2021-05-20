//
//  AccountVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 20/10/2020.
//

import UIKit
import Firebase

protocol SignInVCDelegate: class {
    func didSignIn()
}

class SignInVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "SignInVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var email: MTextField!
    @IBOutlet weak private var password: MTextField!
    @IBOutlet weak private var validButton: FilledButton!
    @IBOutlet weak private var forgetPasswordButton: UIButton!

    // MARK: - Variables
    weak var delegate: SignInVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Privates
    private func setUpView() {
        email.delegate = self
        password.delegate = self
        setUpTranslation()
        setUpTextField()
        setupSignInButton()
    }
    
    private func setUpTranslation() {
        email.placeHolder = L10N.user.form.mail
        password.placeHolder = L10N.user.form.password
        validButton.setTitle(L10N.signIn.form.valid, for: .normal)
        forgetPasswordButton.setTitle(L10N.signIn.form.forgetPassword, for: .normal)
        forgetPasswordButton.titleLabel?.font =  Fonts.SignIn.forgetPassword
    }
    
    private func setUpTextField() {
        email.textContentType = .emailAddress
        email.keyboardType = .emailAddress
        email.returnKeyType = .next
        password.textContentType = .password
        password.isSecureTextEntry = true
        password.returnKeyType = .done
    }
    
    private func setupSignInButton() {
        validButton.titleLabel?.font = Fonts.SignIn.valid
    }
}

// MARK: - IBAction
extension SignInVC {

    @IBAction func dimissToggle() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @IBAction func signInToggle() {
        validButton.loadingIndicator(show: true)
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.validButton.loadingIndicator(show: false)
                self.showError(title: L10N.signIn.title, message: error.localizedDescription)
                return
            }

            ManagerAuth.shared.synchronise {
                self.validButton.loadingIndicator(show: false)
                (UIApplication.shared.delegate as? AppDelegate)?.registerForPushNotifications()
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.delegate?.didSignIn()
                ManagerAuth.shared.didChangeStatus()
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignInVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == email.textField {
            password.textField.becomeFirstResponder()
        } else if textField == password.textField {
            signInToggle()
        }
        return true
    }
}
