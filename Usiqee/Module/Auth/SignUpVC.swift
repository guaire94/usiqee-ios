//
//  SignUpVC.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//

import UIKit
import Firebase

protocol SignUpVCDelegate: class {
    func didSignUp()
}

class SignUpVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "SignUpVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var email: MTextField!
    @IBOutlet weak var password: MTextField!
    @IBOutlet weak var username: MTextField!
    @IBOutlet weak var validButton: UIButton!

    // MARK: - Variables
    weak var delegate: SignUpVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    // MARK: - Privates
    private func setUpView() {
        setUpTranslation()
        setUpTextField()
    }
    
    private func setUpTranslation() {
        titleLabel.text = L10N.signUp.title
        email.placeHolder = L10N.user.form.mail
        password.placeHolder = L10N.user.form.password
        username.placeHolder = L10N.user.form.username
        validButton.setTitle(L10N.signUp.form.valid.uppercased(), for: .normal)
    }
    
    private func setUpTextField() {
        email.delegate = self
        email.textContentType = .emailAddress
        email.returnKeyType = .next
        password.delegate = self
        password.textContentType = .name
        password.returnKeyType = .next
        username.delegate = self
        username.textContentType = .name
        username.returnKeyType = .next
    }
}

// MARK: - IBAction
extension SignUpVC {

    @IBAction func backToggle() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpToggle() {
        validButton.loadingIndicator(show: true)
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){ [weak self] authResult, error in
            guard let self = self else { return }
            self.validButton.loadingIndicator(show: false)
            
            if let error = error {
                self.showError(title: L10N.signUp.title, message: error.localizedDescription)
                return
            }
            ServiceAuth.signUp(mail: self.email.text!, avatar: "", username: self.username.text!)
            self.navigationController?.popViewController(animated: false)
            self.delegate?.didSignUp()
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        
        if textField == email.textField {
            password.textField.becomeFirstResponder()
        } else if textField == password.textField {
            username.textField.becomeFirstResponder()
        } else if textField == username.textField {
            signUpToggle()
        }
        return false
    }
}
