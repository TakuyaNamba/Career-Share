//
//  SearchViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/13.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit

struct Item {
    var imageName: String
    var category: String
}
class SearchViewController: UIViewController {

    var item: String = "test"
    var items: [Item] = [Item(imageName: "1",category: "従業員100人未満"),
                         Item(imageName: "2",category: "従業員300人未満"),
                         Item(imageName: "3",category: "従業員3000人未満"),
                         Item(imageName: "4",category: "従業員3000人以上"),
                         Item(imageName: "5",category: "上場企業"),
                         Item(imageName: "6",category: "未上場企業")]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "企業検索画面"
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItemCollectionViewCell")
        let numberOfItemPerRow: CGFloat = 2
        let lineSpacing: CGFloat = 5
        let interItemSpacing: CGFloat = 5
        let width = (view.frame.width - (numberOfItemPerRow - 1) * interItemSpacing) / numberOfItemPerRow
        let height = width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)//セルの大きさ
        layout.sectionInset = UIEdgeInsets.zero //セクションの外側の余白(margin)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = lineSpacing //行間の余白
        layout.minimumInteritemSpacing = interItemSpacing //列間の余白
        self.collectionView.collectionViewLayout = layout
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToImageViewer" {
            let destinationVC = segue.destination as! ImageViewerViewController
            destinationVC.category = item
        }
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    //表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //表示するセルの登録
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as! ItemCollectionViewCell
        cell.imageView.image = UIImage(named: items[indexPath.row].imageName)
        cell.label.text = items[indexPath.row].category
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        item = items[indexPath.row].category
        performSegue(withIdentifier: "SearchToImageViewer", sender: nil)
    }
}
