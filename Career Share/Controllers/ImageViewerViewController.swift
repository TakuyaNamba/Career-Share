//
//  ImageViewerViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/05/20.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import Firebase

class ImageViewerViewController: UIViewController {

        
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    var companies: [Company] = []
    var companyName: String = "test"
    var category: String = "上場企業"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = category
        tableView.delegate = self
        tableView.dataSource = self
        loadCompanies()
    }
    func loadCompanies() {
        companies = []
        switch category{
            case "従業員100人未満":
                db.collection("companies")
                   .whereField("従業員", isLessThan: 100)
                   .getDocuments { (querySnapshot, error) in
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
        case "従業員300人未満":
            db.collection("companies")
                .whereField("従業員", isLessThan: 300)
                .getDocuments { (querySnapshot, error) in
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
            case "従業員3000人未満":
            db.collection("companies")
                .whereField("従業員", isLessThan: 3000)
                .getDocuments { (querySnapshot, error) in
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
            case "従業員3000人以上":
            db.collection("companies")
                .whereField("従業員", isGreaterThan: 3000)
                .getDocuments { (querySnapshot, error) in
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
            case "上場企業":
            db.collection("companies")
                .whereField("上場", isEqualTo: true)
                .getDocuments { (querySnapshot, error) in
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
            case "未上場企業":
            db.collection("companies")
                .whereField("上場", isEqualTo: false)
                .getDocuments { (querySnapshot, error) in
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
        default:
            print("error")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ImageViewerToReview" {
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.companyName = companyName
        }
    }
}
    extension ImageViewerViewController: UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return companies.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell4", for: indexPath)
            cell.textLabel?.text = companies[indexPath.row].body
            return cell
        }
    }

    extension ImageViewerViewController: UITableViewDelegate {
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            companyName = companies[indexPath.row].body
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "ImageViewerToReview", sender: nil)
        }
    }
