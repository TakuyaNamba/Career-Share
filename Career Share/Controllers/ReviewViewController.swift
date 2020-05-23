//
//  ReviewViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/14.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController {

    let db = Firestore.firestore()
    var companyName: String?
    var reviewRef: DocumentReference?
    var reviewerName: String?
    var review: String = "test"
    var reviews: [Review] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = companyName
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell3")
        loadReviews()
    }
    func loadReviews() {
        if let ID = companyName {
            db.collection("companies").document(ID).collection("reviews")
                .order(by: "date")
                .addSnapshotListener { (querySnapshot, error) in
                    self.reviews = []
                    if let e = error {
                        print(e)
                    } else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let reviewBody = data["body"] as? String, let nicknameBody = data["nickname"] as? String, let pathBody = data["id"] as?  DocumentReference{
                                    let newReview = Review(body: reviewBody, nickname: nicknameBody, path: pathBody)
                                    self.reviews.append(newReview)
                                    
                                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func reviewAdd(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "ReviewToAdd", sender: nil)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReviewToComment" {
            let destinationVC = segue.destination as! CommentReviewViewController
            destinationVC.reviewRef = reviewRef
            destinationVC.reviewerName = reviewerName
            destinationVC.review = review
        }
        else if segue.identifier == "ReviewToAdd" {
            let destinationVC = segue.destination as! ReviewWriteViewController
            destinationVC.companyName = companyName
        }
    }
}
extension ReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell3", for: indexPath) as! MessageCell
        cell.label.text = reviews[indexPath.row].body
        cell.nameLabel.text = reviews[indexPath.row].nickname
        return cell
    }
}
//テーブルをタッチしたときの処理
extension ReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        review = reviews[indexPath.row].body
        reviewerName = reviews[indexPath.row].nickname
        reviewRef = reviews[indexPath.row].path
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ReviewToComment", sender: nil)
    }
}
