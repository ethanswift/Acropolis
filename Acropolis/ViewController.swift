//
//  ViewController.swift
//  Acropolis
//
//  Created by ehsan sat on 6/29/21.
//  Copyright © 2021 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    let screenWidth = UIScreen.main.bounds.width
    
    let screenHeight = UIScreen.main.bounds.height
    
    let guestBtn = UIButton()
    
    let singInBtn = UIButton()
    
    var ref: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        makeViews()
        // Do any additional setup after loading the view.
    }
    
    func makeViews() {
        guestBtn.setTitle("Enter As Guest", for: .normal)
        guestBtn.layer.cornerRadius = 10
        guestBtn.backgroundColor = .systemBlue
        guestBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        guestBtn.addTarget(self, action: #selector(guestBtnClicked), for: .touchUpInside)
        self.view.addSubview(guestBtn)
        guestBtn.translatesAutoresizingMaskIntoConstraints = false
        
        singInBtn.setTitle("Sign In", for: .normal)
        singInBtn.layer.cornerRadius = 10
        singInBtn.backgroundColor = .systemBlue
        singInBtn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        singInBtn.addTarget(self, action: #selector(signInBtnClicked), for: .touchUpInside)
        self.view.addSubview(singInBtn)
        singInBtn.translatesAutoresizingMaskIntoConstraints = false
        
        layoutViews()
    }
    
    @objc func guestBtnClicked() {
        performSegue(withIdentifier: "goToSelect", sender: self)
    }
    
    @objc func signInBtnClicked() {
        performSegue(withIdentifier: "goToSignIn", sender: self)
//        let user = Auth.auth().currentUser
//        self.ref?.child("Users").setValue("something", withCompletionBlock: { (error, ref) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("saved successfully ")
//            }
//        })
        print("button clicked")
        self.ref?.child("Users").setValue(["something": "anotherthing"])
//        print(self.doiArr)
//        refData?.setValue("something")

    }
    
    func layoutViews() {
        NSLayoutConstraint.activate([
            guestBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            guestBtn.widthAnchor.constraint(equalToConstant: 200),
            guestBtn.heightAnchor.constraint(equalToConstant: 50),
            guestBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight / 4)
        ])
        
        NSLayoutConstraint.activate([
            singInBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            singInBtn.widthAnchor.constraint(equalToConstant: 200),
            singInBtn.heightAnchor.constraint(equalToConstant: 50),
            singInBtn.topAnchor.constraint(equalTo: self.view.topAnchor, constant: screenHeight * 5 / 8)
        ])
    }


}

