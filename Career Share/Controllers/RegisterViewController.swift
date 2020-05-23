//
//  ViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/12.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    let db = Firestore.firestore()
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        Auth.auth().removeStateDidChangeListener(handle!)
        print("user remove")
    }

    @IBAction func registerPressed(_ sender: UIButton) {
        if let nickname = nameTextfield.text, let email = emailTextfield.text, let password = passwordTextfield.text{
//            ユーザーを認証登録
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                   if let user = Auth.auth().currentUser {
//                         ユーザー情報をデータベースに登録
                        self.db.collection("users").document(user.uid).setData(["nickname": nickname, "email":email]) { (error) in
                            if let e = error {
                                print(e)
                            } else {
                                print("Registration success!!")
                                print(user.uid)
                            }
                        }
                    }
                    let storyboard: UIStoryboard = self.storyboard!
                    let nextView = storyboard.instantiateViewController(withIdentifier: "NC1")
                    nextView.modalPresentationStyle = .fullScreen
                    let transition = CATransition()
                    transition.duration = 0.25
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(nextView, animated: false, completion: nil)
                }
            }
            
        }
        
        
    }
    

}

