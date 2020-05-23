//
//  QuestionWriteViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/05/18.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class QuestionWriteViewController: UIViewController {

    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!
    var nickname: String = "noName"
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "質問の作成"
        // Do any additional setup after loading the view.
        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { (snap, error) in
            if let error = error {
                fatalError("\(error)")
            }
            guard let data = snap?.data() else { return }
            print(data)
            self.nickname = data["nickname"] as! String
        }
    }
    
    @IBAction func questionPressed(_ sender: UIButton) {
        if let questionBody = textView.text {
                let questionRef = db.collection("questions").document()
                questionRef.setData(["body" : questionBody, "uid": user.uid, "nickname": nickname, "id": questionRef, "date": Date().timeIntervalSince1970]) { (error) in
                    if let e = error {
                        print(e)
                    } else {
                        print("success!!")
                    }
                }
            }
            self.navigationController?.popViewController(animated: true)
    }
}

