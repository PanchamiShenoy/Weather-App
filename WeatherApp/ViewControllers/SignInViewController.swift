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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        addAccessibility()
    }
    override func viewDidAppear(_ animated: Bool) {
        let status = NetworkManager.shared.checkSignIn()
        if(status == true) {
            self.transitionToHome()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setUpView()
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
        signUp.titleLabel?.numberOfLines = 1
        
        signInLabel.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 20))
        email.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        password.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        signUp.titleLabel?.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        
    }
    
    func genericResizableFont(font: UIFont?) -> UIFont {
        return UIFontMetrics.default.scaledFont(for: font ?? UIFont())
    }
    
    @IBAction func createNewAccountClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier:"signupvc")
        vc?.modalPresentationStyle = .fullScreen
        present(vc ?? UIViewController(), animated: true)
        
    }
    
    @IBAction func onSignInClicked(_ sender: Any) {
        if  email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(title: "Error", message: "Please fill all the fields")
            return
        }
        let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] result, error in
            if error != nil {
                self!.showAlert(title: "Error", message: "Error while Signing In")
            }
            else{
                self!.transitionToHome()
            }
        }
    }
    
    func transitionToHome() {
        guard let homeViewController = storyboard?.instantiateViewController(withIdentifier:"homeVC") else { return  }
        navigationController?.pushViewController(homeViewController, animated: true)
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
    }
}
