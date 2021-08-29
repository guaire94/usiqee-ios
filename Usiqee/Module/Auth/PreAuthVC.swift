//
//  PreAuthVC.swift
//  Usiqee
//
//  Created by Amine on 01/05/2021.
//

import UIKit
import AuthenticationServices
import CryptoKit
import Firebase

protocol PreAuthVCDelegate: class {
    func didSignIn()
}

class PreAuthVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak private var signUpButton: FilledButton!
    @IBOutlet weak private var signInWithAppleButton: FilledButton!
    @IBOutlet weak private var signInButton: UIButton!
    @IBOutlet weak private var separatorLabel: UILabel!
    
    // MARK: - Variables
    weak var delegate: PreAuthVCDelegate?
    fileprivate var currentNonce: String?
    
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
        setupSignInWithAppleButton()
        setupSignUpButton()
        setupSeparator()
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func setupSeparator() {
        separatorLabel.font = Fonts.PreAuth.separator
        separatorLabel.text = L10N.preAuth.separator
    }
    
    private func setupSignInButton() {
        signInButton.layer.cornerRadius = 5
        signInButton.clipsToBounds = true
        signInButton.setBackgroundColor(Colors.gray.withAlphaComponent(0.7))
        signInButton.titleLabel?.font = Fonts.PreAuth.signIn
        signInButton.setTitle(L10N.preAuth.signIn, for: .normal)
    }
    
    private func setupSignInWithAppleButton() {
        guard #available(iOS 13, *) else {
            signInWithAppleButton.isHidden = true
            return
        }
        
        signInWithAppleButton.layer.cornerRadius = 25
        signInWithAppleButton.color = .black
        signInWithAppleButton.titleLabel?.font = Fonts.PreAuth.signUp
        signInWithAppleButton.setTitle(L10N.preAuth.signInWithApple, for: .normal)
    }
    
    private func setupSignUpButton() {
        signUpButton.layer.cornerRadius = 25
        signUpButton.titleLabel?.font = Fonts.PreAuth.signUp
        signUpButton.setTitle(L10N.preAuth.signUp, for: .normal)
    }
    
}

// MARK: - IBActions
extension PreAuthVC {
    @IBAction func onDismissToggle() {
        dismiss(animated: true, completion: nil)
    }
    
    @available(iOS 13, *)
    @IBAction func signInWithAppleToggle() {
        let nonce = String.randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
        signInWithAppleButton.loadingIndicator(show: true)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
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

// MARK: - ASAuthorizationControllerDelegate
@available(iOS 13.0, *)
extension PreAuthVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                guard error == nil, let authResult = authResult else {
                    self.signInWithAppleButton.loadingIndicator(show: false)
                    self.showError(title: L10N.signIn.title, message: error?.localizedDescription ?? "")
                    return
                }
                
                let mail = authResult.user.email ?? ""
                let username = appleIDCredential.fullName?.username ?? ""
                                
                ServiceAuth.signUp(mail: mail, avatar: "", username: username)
                (UIApplication.shared.delegate as? AppDelegate)?.registerForPushNotifications()
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.delegate?.didSignIn()
                ManagerAuth.shared.didChangeStatus()
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        signInWithAppleButton.loadingIndicator(show: false)
        showError(title: L10N.signIn.title, message: error.localizedDescription)
    }
    
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
@available(iOS 13.0, *)
extension PreAuthVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        view.window!
    }
}
