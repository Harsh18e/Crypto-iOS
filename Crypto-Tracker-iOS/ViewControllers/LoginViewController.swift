//
//  LoginViewController.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 05/03/23.
//

import UIKit
import Lottie
import Foundation

class LoginViewController: UIViewController {

    // MARK: Private IBOutlets
    @IBOutlet private weak var statusView: CustomUIView!
    @IBOutlet private weak var credLogo: UIView!
    @IBOutlet private weak var downArrow: UIImageView!
    @IBOutlet private weak var dragCircle: CustomUIView!
    @IBOutlet private weak var logoContainerView: CustomUIView!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var apiStatus: UISegmentedControl!
    @IBOutlet private weak var loadingAnimationView: CustomUIView!
    
    // MARK: Private Properties
    private var isDraggingVertically = false
    private var statusViewFrame: CGPoint!
    private var isSuccessEnabled: Bool = true
    private var animationManager: AnimationManager?
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationManager = AnimationManager()
        statusViewFrame = statusView.center
        animationManager?.animateUpAndDown(credLogo)
        animationManager?.startBlinkTimer(downArrow)
    }
    
    // MARK: Private Methods
    private func handleResult(_ result: Bool) {
        DispatchQueue.main.sync {
            self.statusLabel.text = result ? "success" : "failure"
            UIView.animate(withDuration: 1, delay: 0) {
                self.statusLabel.transform = CGAffineTransform(translationX: 0, y: -100)
            }
            UIView.animate(withDuration: 1, delay: 0) {
                self.dragCircle.frame.origin.y += self.view.frame.height
            }
            UIView.animate(withDuration: 1, delay: 0) {
                self.statusView.frame.origin.y -= 10
            }
            self.animationManager?.stopLoadingAnimation()
        }
        
        //resetting after 5 sec
        resetUI()
    }
    
    private func resetUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            
            guard let strongSelf = self else { return }
            
            strongSelf.dragCircle.isHidden = false
            strongSelf.downArrow.isHidden = false
            strongSelf.credLogo.isHidden = false
            strongSelf.credLogo.center = strongSelf.logoContainerView.center
            strongSelf.animationManager?.animateUpAndDown(strongSelf.credLogo)
            
            UIView.animate(withDuration: 0.8, delay: 0) {
                strongSelf.statusLabel.transform = CGAffineTransform(translationX: 0, y: 100)
            }
            UIView.animate(withDuration: 0.8, delay: 0) {
                strongSelf.dragCircle.center = strongSelf.loadingAnimationView.center
            }
            UIView.animate(withDuration: 0.8, delay: 0) {
                strongSelf.statusView.center = strongSelf.statusViewFrame
                strongSelf.statusView.center.x = strongSelf.logoContainerView.center.x
            }
        }
    }
    
    // MARK: Making Network Call
    private func makeNetworkCall() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            NetworkManager.shared.apiCall(self.isSuccessEnabled) { [weak self] result in
                
                guard let strongSelf = self else { return }
                
                switch result {
                case .success(let response):
                    print(response)
                    
                case .failure(.unableToParse):
                    strongSelf.handleResult(false)
                    
                case .failure(.apiError):
                    strongSelf.handleResult(false)
                }
            }
        }
    }
    
    // MARK: IBAction - Toggle API
    @IBAction func toggleApiStatus(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                isSuccessEnabled = true
                break
            case 1:
                isSuccessEnabled = false
                break
        default:
            isSuccessEnabled = true
            break
        }
    }
}

// MARK: Touch Interaction Methods
extension LoginViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: logoContainerView)
        if logoContainerView.bounds.contains(location) {
            print("touch started")
            animationManager?.stopLogoAnimation(credLogo)
            isDraggingVertically = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDraggingVertically, let touch = touches.first else {
            return
        }
        let location = touch.location(in: view)
        credLogo.frame.origin.y = location.y - credLogo.bounds.height
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch finished")
        guard isDraggingVertically, let touch = touches.first else {
            animationManager?.animateUpAndDown(credLogo)
            return
        }
        let location = touch.location(in: dragCircle)
        
        if dragCircle.bounds.contains(location) {
            self.credLogo.center = self.dragCircle.center
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.downArrow.isHidden = true
                strongSelf.credLogo.isHidden = true
                strongSelf.animationManager?.startLoadingAnimation(strongSelf.loadingAnimationView)
            }
            makeNetworkCall()
        } else {
            credLogo.center = logoContainerView.center
            animationManager?.animateUpAndDown(credLogo)
        }
        
        isDraggingVertically = false
    }
}

