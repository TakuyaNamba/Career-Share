//
//  CommentQuestionViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/05/18.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class CommentQuestionViewController: UIViewController {

    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!
    var questionerName :String?
    var question :String?
    var questionRef :DocumentReference?
    var comments :[Comment] = []
    var nickname: String = "noName"
    
    
    @IBOutlet weak var questionerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = questionerName
        questionLabel.text = question ?? "nothing"
        questionerLabel.text = questionerName ?? "nothing"
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell3")
        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { (snap, error) in
            if let error = error {
                fatalError("\(error)")
            }
            guard let data = snap?.data() else { return }
            print(data)
            self.nickname = data["nickname"] as! String
        }
        loadComments()
        // Do any additional setup after loading the view.
    }
    func loadComments() {
            if let docRef = questionRef {
                docRef.collection("comments")
                    .order(by: "date")
                    .addSnapshotListener { (querySnapshot, error) in
                    self.comments = []
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let commentBody = data["body"] as? String, let nicknameBody = data["nickname"] as? String{
                                    let newComment = Comment(body: commentBody, nickname: nicknameBody)
                                    self.comments.append(newComment)

                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                        let indexPath = IndexPath(row: self.comments.count - 1, section: 0)
                                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    @IBAction func commentPressed(_ sender: UIButton) {
        if let commentBody = textField.text, let docRef = questionRef {
             let commentRef = docRef.collection("comments").document()
            commentRef.setData(["body" : commentBody, "uid": user.uid, "nickname": nickname, "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error {
                    print(e)
                } else {
                    print("success!!")
                    DispatchQueue.main.async {
                        self.textField.text = ""
                    }
                }
            }
        }
        print(textField.text!)
    }
}

extension CommentQuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell3", for: indexPath) as! MessageCell
        cell.label.text = comments[indexPath.row].body
        cell.nameLabel.text = comments[indexPath.row].nickname
        return cell
    }
}

