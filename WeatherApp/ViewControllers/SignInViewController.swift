//
//  SignInViewController.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 2/16/23.
//
import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    @IBOutlet weak private var email: UITextField!
    @IBOutlet weak private var password: UITextField!
    @IBOutlet weak private var signIn: UIButton!
    @IBOutlet weak private var signUp: UIButton!
    @IBOutlet weak private var signInLabel: UILabel!
    let constants = UiConstants()
    let viewModel = SignInViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addAccessibility()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkedIfSignedIn()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setUpFont()
        }
    }
    
    func checkedIfSignedIn() {
        let status = viewModel.checkSignedIn()
        if(status == true) {
            self.transitionToHome()
        }
    }
    
    func setUpView() {
        email.layer.borderWidth = 0.5
        password.layer.borderWidth = 0.5
        email.layer.borderColor = UIColor.white.cgColor
        password.layer.borderColor = UIColor.white.cgColor
        email.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        signIn.layer.cornerRadius = 20
        setUpFont()
    }
    
    func setUpFont() {
        signInLabel.font = genericResizableFont(font: constants.avenirBookBody)
        email.font = genericResizableFont(font: constants.avenirBookBody)
        password.font = genericResizableFont(font: constants.avenirBookBody)
        signUp.titleLabel?.font = genericResizableFont(font: constants.avenirBookBody)
        signUp.titleLabel?.numberOfLines = 1
        signUp.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func createNewAccountClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VcIdentifier.signupVC.rawValue)
        vc?.modalPresentationStyle = .fullScreen
        present(vc ?? UIViewController(), animated: true)
        
    }
    
    @IBAction func onSignInClicked(_ sender: Any) {
        if  email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: SignInVcConstants.errorString.rawValue, message: SignInVcConstants.pleaseFillAllDetails.rawValue)
            return
        }
        let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        viewModel.signIn(email: email, password: password) { results, error in
            if error != nil {
                self.showAlert(title: SignInVcConstants.errorString.rawValue, message: SignInVcConstants.errorWhileSigningIn.rawValue)
            }
            else{
                self.transitionToHome()
            }
        }
        
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
        signIn.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        email.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        password.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
        signUp.accessibilityHint = AccessibilityConstants.doubleTapToActive.rawValue
    }
}

enum SignInVcConstants: String {
    case errorString = "Error"
    case pleaseFillAllDetails = "Please fill all the fields"
    case errorWhileSigningIn = "Error while Signing In"
    
}
