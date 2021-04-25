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
    func didSignUp()
}

class SignInVC: UIViewController {
    
    // MARK: - Constants
    enum Constants {
        static var identifier = "SignInVC"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var email: MTextField!
    @IBOutlet weak private var password: MTextField!
    @IBOutlet weak private var validButton: UIButton!
    @IBOutlet weak private var noAccountLabel: UILabel!
    @IBOutlet weak private var signUpLabel: UILabel!

    // MARK: - Variables
    weak var delegate: SignInVCDelegate?

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SignUpVC.Constants.identifier {
            guard let vc = segue.destination as? SignUpVC else { return }
            vc.delegate = self
        }
    }
    
    // MARK: - Privates
    private func setUpView() {
        if #available(iOS 13.0, *) {
            navigationController?.isModalInPresentation = true
        }
        email.delegate = self
        password.delegate = self
        setUpTranslation()
        setUpTextField()
    }
    
    private func setUpTranslation() {
        titleLabel.text = L10N.signIn.title
        email.placeHolder = L10N.user.form.mail
        password.placeHolder = L10N.user.form.password
        validButton.setTitle(L10N.signIn.form.valid.uppercased(), for: .normal)
        noAccountLabel.text = L10N.signIn.noAccount
        signUpLabel.text = L10N.signUp.title.uppercased()        
    }
    
    private func setUpTextField() {
        email.textContentType = .emailAddress
        email.returnKeyType = .next
        password.textContentType = .name
        password.returnKeyType = .done
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
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.delegate?.didSignIn()
            }
        }
    }

    @IBAction func becomeCoachToggle() {
        performSegue(withIdentifier: SignUpVC.Constants.identifier, sender: self)
    }
}

// MARK: - SignUpVCDelegate
extension SignInVC: SignUpVCDelegate {

    func didSignUp() {
        navigationController?.dismiss(animated: true, completion: nil)
        delegate?.didSignUp()
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
