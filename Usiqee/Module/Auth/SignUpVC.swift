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
        fileprivate static let imageContentType = "image/jpeg"
    }

    // MARK: - IBOutlet
    @IBOutlet weak private var avatar: MImagePicker!
    @IBOutlet weak private var email: MTextField!
    @IBOutlet weak private var password: MTextField!
    @IBOutlet weak private var username: MTextField!
    @IBOutlet weak private var validButton: FilledButton!

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
        setupValidateButton()
        avatar.parentViewController = self
    }
    
    private func setUpTranslation() {
        email.placeHolder = L10N.user.form.mail
        password.placeHolder = L10N.user.form.password
        username.placeHolder = L10N.user.form.username
        validButton.setTitle(L10N.signUp.form.valid, for: .normal)
    }
    
    private func setUpTextField() {
        email.delegate = self
        email.textContentType = .emailAddress
        email.keyboardType = .emailAddress
        email.returnKeyType = .next
        password.delegate = self
        if #available(iOS 12.0, *) {
            password.textContentType = .newPassword
        } else {
            password.textContentType = .password
        }
        password.isSecureTextEntry = true
        password.returnKeyType = .done
        username.delegate = self
        username.textContentType = .name
        username.returnKeyType = .next
    }
    
    private func setupValidateButton() {
        validButton.titleLabel?.font = Fonts.SignUp.valid
    }
}

// MARK: - IBAction
extension SignUpVC {

    @IBAction func backToggle() {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func signUpToggle() {
        guard let email = email.text,
              !email.isEmpty,
              let username = username.text,
              !username.isEmpty,
              let password = password.text,
              !password.isEmpty else {
            self.showError(title: L10N.signUp.title, message: L10N.signUp.form.notEmptyError)
            return
        }
        
        validButton.loadingIndicator(show: true)
        Auth.auth().createUser(withEmail: email, password: password){ [weak self] authResult, error in
            guard let self = self else { return }
            self.validButton.loadingIndicator(show: false)
            
            if let error = error {
                self.showError(title: L10N.signUp.title, message: error.localizedDescription)
                return
            }
            
            self.handleUserIsCreated(email: email, username: username)
        }
    }
    
    private func handleUserIsCreated(email: String, username: String) {
        guard let image = avatar.image else {
            handleAvatarIsUploaded(email: email, username: username)
            return
        }
        
        upload(image: image) { [weak self] url in
            guard let url = url?.absoluteString else {
                self?.handleAvatarIsUploaded(email: email, username: username)
                return
            }
            self?.handleAvatarIsUploaded(email: email, username: username, avatar: url)
        }
    }
    
    private func handleAvatarIsUploaded(email: String, username: String, avatar: String = "") {
        ServiceAuth.signUp(mail: email, avatar: avatar, username: username)
        (UIApplication.shared.delegate as? AppDelegate)?.registerForPushNotifications()
        navigationController?.popViewController(animated: false)
        delegate?.didSignUp()
        ManagerAuth.shared.didChangeStatus()
    }
    
    private func upload(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid,
            let scaledImage = image.scaledToSafeUploadSize,
            let data = scaledImage.jpegData(compressionQuality: 0.4) else {
                completion(nil)
                return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = Constants.imageContentType
        
        FStorageReference.user(userId: userId).putData(data, metadata: metadata) { meta, error in
            FStorageReference.user(userId: userId).downloadURL { url, _ in
                completion(url)
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField {
        case username.textField:
            email.textField.becomeFirstResponder()
        case email.textField:
            password.textField.becomeFirstResponder()
        case password.textField:
            signUpToggle()
        default:
            break
        }
        
        return false
    }
}
