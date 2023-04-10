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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setUp()
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
        signIn.titleLabel?.adjustsFontForContentSizeCategory = true
        signUpLabel.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 20))
        //signUpLabel.adjustsFontForContentSizeCategory = true
        alreadyHaveAccountLabel.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        email.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        //email.adjustsFontForContentSizeCategory = true
        password.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        //password.adjustsFontForContentSizeCategory = true
        firstName.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        //firstName.adjustsFontForContentSizeCategory = true
        lastName.font = genericResizableFont(font: UIFont(name: "Avenir Book", size: 15))
        //lastName.adjustsFontForContentSizeCategory = true
        //alreadyHaveAccountLabel.minimumScaleFactor = 0.4
        //alreadyHaveAccountLabel.adjustsFontSizeToFitWidth = true
        
    }
    
    @IBAction func onClickSignIn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func onClickSignUp(_ sender: Any) {
        let error = validateFields()
        
        if error != nil {
            showAlert(title: "Error", message:error!)
        }else{
            
            let firstName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password){ [weak self] result, error in
                if error != nil {
                    self!.showAlert(title: "Error", message: "Error while creating user")
                }
                else{
                    let userDetails: [String: Any] = ["firstname": firstName,"lastname":secondName,"uid": result!.user.uid]
                    NetworkManager.shared.writeDocument(documentName: "users",data: userDetails)
                    self!.transitionToHome()
                    
                }
                
            }
        }
    }
    
    func validateFields() -> String? {
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in all details"
        }
        let cleanemail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isEmailValid(cleanemail) == false {
            return "please enter a valid email "
        }
        let cleanpassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanpassword) == false {
            return "please enter a valid password "
        }
        return nil
    }
    
    func transitionToHome() {
         let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
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
}
