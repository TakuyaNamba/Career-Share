//
//  HomeViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/12.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var companies: [Company] = []
    var companyName: String = "test"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "IT企業一覧画面"
        tableView.delegate = self
        tableView.dataSource = self
        loadCompanies()
    }
    
    func loadCompanies() {
        companies = []
        db.collection("companies").getDocuments { (querySnapshot, error) in
            if let e = error {
                print(e)
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let companyBody = data["body"] as? String {
                            let newCompany = Company(body: companyBody)
                            self.companies.append(newCompany)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "LoginVC")
            nextView.modalPresentationStyle = .fullScreen
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(nextView, animated: false, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToReview" {
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.companyName = companyName
        }
    }
}
extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell1", for: indexPath)
        cell.textLabel?.text = companies[indexPath.row].body
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        companyName = companies[indexPath.row].body
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "HomeToReview", sender: nil)
    }
}
