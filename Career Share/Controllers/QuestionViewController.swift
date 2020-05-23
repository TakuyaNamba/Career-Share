//
//  QuestionViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/14.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController {

    let db = Firestore.firestore()
    var questionRef: DocumentReference?
    var questionerName: String?
    var question: String = "test"
    var questions: [Question] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "何でも質問"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell3")
        loadQuestions()
    }
    func loadQuestions() {
            db.collection("questions")
                .order(by: "date")
                .addSnapshotListener { (querySnapshot, error) in
                    self.questions = []
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let questionBody = data["body"] as? String, let nicknameBody = data["nickname"] as? String, let pathBody = data["id"] as?  DocumentReference{
                                    let newQuestion = Question(body: questionBody, nickname: nicknameBody, path: pathBody)
                                    self.questions.append(newQuestion)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
    }
    @IBAction func questionAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "QuestionToAdd", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuestionToComment" {
            let destinationVC = segue.destination as! CommentQuestionViewController
            destinationVC.questionRef = questionRef
            destinationVC.questionerName = questionerName
            destinationVC.question = question
        }
    }
}
extension QuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell3", for: indexPath) as! MessageCell
        cell.label.text = questions[indexPath.row].body
        cell.nameLabel.text = questions[indexPath.row].nickname
        return cell
    }
}
//テーブルをタッチしたときの処理
extension QuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        question = questions[indexPath.row].body
        questionerName = questions[indexPath.row].nickname
        questionRef = questions[indexPath.row].path
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "QuestionToComment", sender: nil)
    }
}
