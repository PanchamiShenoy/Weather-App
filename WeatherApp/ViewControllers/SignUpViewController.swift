//
//  SignUpViewController.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 2/16/23.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak private var firstName: UITextField!
    @IBOutlet weak private var lastName: UITextField!
    @IBOutlet weak private var email: UITextField!
    @IBOutlet weak private var password: UITextField!
    @IBOutlet weak private var signUp: UIButton!
    @IBOutlet weak private var signIn: UIButton!
    @IBOutlet weak private var signUpLabel: UILabel!
    @IBOutlet weak private var alreadyHaveAccountLabel: UILabel!
    let constants = UiConstants()
    let viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        addAccessibility()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setUpFont()
        }
    }
    
    func setUp() {
        firstName.layer.borderWidth = 0.5
        lastName.layer.borderWidth = 0.5
        email.layer.borderWidth = 0.5
        password.layer.borderWidth = 0.5
        email.layer.borderColor = UIColor.white.cgColor
        password.layer.borderColor = UIColor.white.cgColor
        firstName.layer.borderColor = UIColor.white.cgColor
        lastName.layer.borderColor = UIColor.white.cgColor
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        firstName.layer.cornerRadius = 10
        lastName.layer.cornerRadius = 10
        signIn.titleLabel?.numberOfLines = 1
        setUpFont()
    }
    
    func setUpFont() {
        signUpLabel.font = genericResizableFont(font: constants.avenirBookBody)
        alreadyHaveAccountLabel.font = genericResizableFont(font: constants.avenirBookBody)
        email.font = genericResizableFont(font: constants.avenirBookBody)
        password.font = genericResizableFont(font: constants.avenirBookBody)
        firstName.font = genericResizableFont(font: constants.avenirBookBody)
        lastName.font = genericResizableFont(font: constants.avenirBookBody)
        alreadyHaveAccountLabel.font =  genericResizableFont(font: constants.avenirBookBody)
        alreadyHaveAccountLabel.adjustsFontSizeToFitWidth = true
        alreadyHaveAccountLabel.minimumScaleFactor = 0.1
        signIn.titleLabel?.adjustsFontSizeToFitWidth = true
        signIn.titleLabel?.minimumScaleFactor = 0.1
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showAlert(title: SignUpVcConstants.errorString.rawValue, message:error!)
        }else{
            
            let firstName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            viewModel.signUp(email: email, password: password) { [weak self] result, error in
                if error != nil {
                    self?.showAlert(title: SignUpVcConstants.errorString.rawValue, message: SignUpVcConstants.errorWhileCreatingUser.rawValue)
                }
                else{
                    let userDetails: [String: Any] = ["firstname": firstName,"lastname":secondName,"uid": result!.user.uid]
                    self?.viewModel.saveUserDetails(userDetails: userDetails)
                    self?.transitionToHome()
                    
                }
            }
        }
    }
        
        func validateFields() -> String? {
            if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return SignUpVcConstants.enterAllFields.rawValue
            }
            let cleanemail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if isEmailValid(cleanemail) == false {
                return SignUpVcConstants.enterValidEmail.rawValue
            }
            let cleanpassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if isPasswordValid(cleanpassword) == false {
                return SignUpVcConstants.enterValidPassword.rawValue
            }
            return nil
        }
        
        func transitionToHome() {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: VcIdentifier.homeVC.rawValue) as! HomeViewController
            let navigationController = UINavigationController(rootViewController: vc)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction(title: "OK", style: .default) { (okclick) in
                
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
        func addAccessibility() {
            email.isAccessibilityElement = true
            email.accessibilityLabel = ""
            password.isAccessibilityElement = true
            password.accessibilityLabel = ""
            firstName.isAccessibilityElement = true
            firstName.accessibilityLabel = ""
            lastName.isAccessibilityElement = true
            lastName.accessibilityLabel = ""
            firstName.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
            lastName.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
            signIn.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
            email.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
            password.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
            signUp.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        }
    }
    
    enum SignUpVcConstants: String {
        case errorString = "Error"
        case errorWhileCreatingUser = "Error while creating user"
        case enterAllFields = "Please fill in all details"
        case enterValidEmail = "Please enter a valid email"
        case enterValidPassword = "Please enter a valid password"
    }
