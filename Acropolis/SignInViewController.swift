//
//  SignInViewController.swift
//  Acropolis
//
//  Created by ehsan sat on 6/30/21.
//  Copyright © 2021 ehsan sat. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    
    let screenHeight = UIScreen.main.bounds.height
    
    let emailTxtFld = UITextField()
    
    let passTxtFld = UITextField()
    
    let newUserBtn = UIButton()
    
    let signInBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeViews()

        // Do any additional setup after loading the view.
    }
    
    func makeViews() {
        
        newUserBtn.setTitle("Create New Account", for: .normal)
        newUserBtn.layer.cornerRadius = 10
        newUserBtn.backgroundColor = .systemBlue
        newUserBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        newUserBtn.addTarget(self, action: #selector(newUserBtnClicked), for: .touchUpInside)
        self.view.addSubview(newUserBtn)
        newUserBtn.translatesAutoresizingMaskIntoConstraints = false
        
        signInBtn.setTitle("Sign In", for: .normal)
        signInBtn.layer.cornerRadius = 10
        signInBtn.backgroundColor = .systemBlue
        signInBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        signInBtn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        self.view.addSubview(signInBtn)
        signInBtn.translatesAutoresizingMaskIntoConstraints = false

        
        emailTxtFld.placeholder = "Enter Email"
        emailTxtFld.borderStyle = .roundedRect
        self.view.addSubview(emailTxtFld)
        emailTxtFld.translatesAutoresizingMaskIntoConstraints = false
        
        passTxtFld.placeholder = "Enter Password"
        passTxtFld.borderStyle = .roundedRect
        self.view.addSubview(passTxtFld)
        passTxtFld.translatesAutoresizingMaskIntoConstraints = false

        layoutViews()
    }
    
    @objc func newUserBtnClicked() {
        
        if let email = self.emailTxtFld.text, let pass = self.passTxtFld.text {

        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            
            if let firebaseError = error {
                print(firebaseError.localizedDescription)
                print("firebase error")
                return
            }
            if let user = authResult {
                print(user)
                self.performSegue(withIdentifier: "goToUser", sender: self)
            }
          }
        }
        
    }
    
    @objc func signInBtnClicked() {
        
        if let email = self.emailTxtFld.text, let pass = self.passTxtFld.text {
            Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in

                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    print("firebase error")
                    return
                }
                
                if let user = authResult {
                    print(user)
                    self.performSegue(withIdentifier: "goToUser", sender: self)
                }
            }

        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.emailTxtFld.endEditing(true)
        self.passTxtFld.endEditing(true)
        self.emailTxtFld.resignFirstResponder()
        self.passTxtFld.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTxtFld.endEditing(true)
        self.passTxtFld.endEditing(true)
        self.emailTxtFld.resignFirstResponder()
        self.passTxtFld.resignFirstResponder()
        return true
    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            emailTxtFld.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailTxtFld.widthAnchor.constraint(equalToConstant: 200),
            emailTxtFld.heightAnchor.constraint(equalToConstant: 50),
            emailTxtFld.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight * 3 / 8)
        ])
        
        NSLayoutConstraint.activate([
            passTxtFld.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passTxtFld.widthAnchor.constraint(equalToConstant: 200),
            passTxtFld.heightAnchor.constraint(equalToConstant: 50),
            passTxtFld.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight * 2 / 4)
        ])
        
        NSLayoutConstraint.activate([
            newUserBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            newUserBtn.widthAnchor.constraint(equalToConstant: 200),
            newUserBtn.heightAnchor.constraint(equalToConstant: 50),
            newUserBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight * 6 / 8)
        ])
        
        NSLayoutConstraint.activate([
            signInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            signInBtn.widthAnchor.constraint(equalToConstant: 200),
            signInBtn.heightAnchor.constraint(equalToConstant: 50),
            signInBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight * 7 / 8)
        ])

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
