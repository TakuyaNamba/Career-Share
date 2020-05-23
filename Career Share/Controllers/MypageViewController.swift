//
//  MypageViewController.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/13.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CropViewController

class MypageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "マイページ"
        imagePicker.delegate = self
        let docRef = db.collection("users").document(user.uid)
        docRef.getDocument { (snap, error) in
            if let error = error {
                fatalError("\(error)")
            }
            guard let data = snap?.data() else { return }
            print(data)
            self.nicknameLabel.text = data["nickname"] as? String
            let url = URL(string: data["image"] as? String ?? "nothing")
            self.imageView.loadImageAsynchronously(url: url, defaultUIImage: UIImage(named: "default"))
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func presentImagePicker(_ sender: UIButton) {
        imagePicker.allowsEditing = false //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func presentCropViewController(_ sender: UIButton) {
        guard let chosenImage = self.imageView.image else {
            dismiss(animated: true, completion: nil)
            return
        }
        let cropViewController = CropViewController(image: chosenImage)
        cropViewController.doneButtonTitle = "切り抜く"
        cropViewController.cancelButtonTitle = "キャンセル"
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    @IBAction func startUpload(_ sender: UIButton) {
        saveToFireStore()
    }
    fileprivate func upload(completed: @escaping(_ url: String?) -> Void) {
        let date = NSDate()
        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        let storageRef = Storage.storage().reference().child("images").child("\(currentTimeStampInSecond).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    completed(nil)
                    print("error: \(error?.localizedDescription)")
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        completed(nil)
                        print("error: \(error?.localizedDescription)")
                    }
                    completed(url?.absoluteString)
                })
            }
        }
    }
    
    fileprivate func saveToFireStore(){
        var data: [String : Any] = [:]
        upload(){ url in
            guard let url = url else {return }
            data["image"] = url
            Firestore.firestore().collection("users").document(self.user.uid).setData(data, merge: true){ error in
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                }
                print("image saved!")
            }
        }
    }
}
extension UIImageView {
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) -> Void {

        if url == nil {
            self.image = defaultUIImage
            return
        }

        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}
extension MypageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
 
extension MypageViewController: CropViewControllerDelegate {
        
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        dismiss(animated: true, completion: nil)
    }
 
}
