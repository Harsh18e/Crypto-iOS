//
//  LoginViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import UIKit
import Lottie
import Foundation
import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseCore

class LoginViewController: UIViewController {
    
    // MARK: Private IBOutlets
    @IBOutlet private weak var statusView: CustomUIView!
    @IBOutlet private weak var credLogo: UIView!
    @IBOutlet private weak var downArrow: UIImageView!
    @IBOutlet private weak var dragCircle: CustomUIView!
    @IBOutlet private weak var logoContainerView: CustomUIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet private weak var loadingAnimationView: CustomUIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toggleButton: UISegmentedControl!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var googleUIView: CustomUIView!
    
    // MARK: Private Properties
    private var isDraggingVertically = false
    private var statusViewFrame: CGPoint!
    private var loginViewModel: LoginViewModel?
    private var loginMethod: LoginType = .email {
        didSet {
            updateUIForLoginMethod()
        }
    }
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginViewModel = LoginViewModel()
        statusViewFrame = statusView.center
        loginViewModel?.animateUpAndDown(credLogo)
        loginViewModel?.startBlinkTimer(downArrow)
        loginViewModel?.addLayerGradient(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnGoogle(_:)))
        googleUIView.addGestureRecognizer(tapGesture)
        googleUIView.isUserInteractionEnabled = true
       
        updateUIForLoginMethod()
    }
    
    // MARK: Private Methods
    
    @IBAction func toggleButtonClicked(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
            
            // Perform actions based on the selected segment
            switch selectedIndex {
            case 0:
                loginMethod = .email
            case 1:
                loginMethod = .signUp
            default:
                break
            }
    }
    
    @objc private func tappedOnGoogle(_ sender: Any) {
        if loginMethod != .google {
            loginMethod = .google
        }
    }
    
    private func updateUIForLoginMethod() {
        // Update the UI based on the current login method
        switch loginMethod {
        case .email:
            googleUIView.layer.borderColor = UIColor.clear.cgColor
            enableTextFields()
            
        case .google:
            googleUIView.layer.borderColor = UIColor.blue.cgColor
            toggleButton.selectedSegmentIndex = -1
            disableTextFields()
            
        case .signUp:
            googleUIView.layer.borderColor = UIColor.clear.cgColor
            enableTextFields()
        }
    }
    
    private func disableTextFields() {
        emailTextField.isEnabled = false
        passwordTextField.isEnabled = false
        emailTextField.alpha = 0.4
        passwordTextField.alpha = 0.4
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    private func enableTextFields() {
        emailTextField.isEnabled = true
        passwordTextField.isEnabled = true
        emailTextField.alpha = 1
        passwordTextField.alpha = 1
        passwordTextField.text = ""
        emailTextField.text = ""
    }
    
    private func resetUI() {
        
        updateUIForLoginMethod()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.dragCircle.isHidden = false
            strongSelf.downArrow.isHidden = false
            strongSelf.credLogo.isHidden = false
            strongSelf.credLogo.center = strongSelf.logoContainerView.center
            strongSelf.loginViewModel?.animateUpAndDown(strongSelf.credLogo)
            strongSelf.loginViewModel?.stopLoadingAnimation()
            
            UIView.animate(withDuration: 0.8, delay: 0) {
                strongSelf.dragCircle.center = strongSelf.loadingAnimationView.center
            }
            UIView.animate(withDuration: 0.8, delay: 0) {
                strongSelf.statusView.center = strongSelf.statusViewFrame
                strongSelf.statusView.center.x = strongSelf.logoContainerView.center.x
            }
            
            strongSelf.view.isUserInteractionEnabled = true
        }
    }
    
    private func handleLoginResult(_ result: Result<UserType, Error>) {
        
        switch result {
        case .success(let user):
            
            switch user {
            case .firebaseUser(let user):
                print("Firebase login successful: \(user)")
                goToHomePage()
            case .googleUser(let user):
                print("Firebase login successful: \(user)")
                goToHomePage()
            }
            
        case .failure(let error):
            // Handle login failure
            print("Login failure: \(error)")
            self.showAlertController(withTitle: "\(error.localizedDescription)", actionHandler: { action in
                self.dismiss(animated: true)
            })
            self.resetUI()
        }
    }
    
    private func goToHomePage() {
        
        self.resetUI()
        
        UserDefaults.standard.set(true, forKey: Constants.LOGINSTATUS)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        let navigationController = CustomNavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }

}

// MARK: Touch Interaction Methods
extension LoginViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: credLogo)
        if logoContainerView.bounds.contains(location) {
            print("touch started")
            loginViewModel?.stopLogoAnimation(credLogo)
            isDraggingVertically = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraggingVertically, let touch = touches.first else {
            return
        }
        let location = touch.location(in: view)
        credLogo.center.y = location.y - credLogo.bounds.height
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch finished")
        guard isDraggingVertically, let touch = touches.first else {
            loginViewModel?.animateUpAndDown(credLogo)
            return
        }
        let location = touch.location(in: dragCircle)
        
        if dragCircle.bounds.contains(location) {
            
            self.credLogo.center = self.dragCircle.center
            downArrow.isHidden = true
            credLogo.isHidden = true
            loginViewModel?.startLoadingAnimation(loadingAnimationView)
            view.isUserInteractionEnabled = false
            
            loginViewModel?.requestLogin(self,loginMethod) { result in
                self.handleLoginResult(result)
            }
        } else {
            credLogo.center = logoContainerView.center
            loginViewModel?.animateUpAndDown(credLogo)
        }
        
        isDraggingVertically = false
    }
}

