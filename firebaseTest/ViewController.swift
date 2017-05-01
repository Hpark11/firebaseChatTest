//
//  ViewController.swift
//  firebaseTest
//
//  Created by hPark_ipl on 2017. 4. 25..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

// 1. 내가 작성한 내용이 파이어베이스에 저장되게 한다.
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var item: UINavigationItem!
    
    var groupKey: String? {
        didSet {
            if let key = groupKey {
                FirebaseDataService.instance.groupRef.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let data = snapshot.value as? Dictionary<String, AnyObject> {
                        if let title = data["name"] as? String {
                            self.item.title = title
                        }
                    }
                })
            }
        }
    }
    
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
    }
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    // cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 140)
    }

    @IBAction func sendButtonTapped(_ sender: UIButton) {
        let ref = FirebaseDataService.instance.messageRef.childByAutoId()
        guard let fromUserId = FirebaseDataService.instance.currentUserUid else {
            return
        }
        
        let data: Dictionary<String, AnyObject> = [
            "fromUserId": fromUserId as AnyObject,
            "text": chatTextField.text! as AnyObject,
            "timestamp": NSNumber(value: Date().timeIntervalSince1970)
        ]
        
        ref.updateChildValues(data) { (err, ref) in
            guard err == nil else {
                print(err as Any)
                return
            }
            
            self.chatTextField.text = nil
            if let groupId = self.groupKey {
                FirebaseDataService.instance.groupRef.child(groupId).child("messages").updateChildValues([ref.key: 1])
            }
        }
    }
}

