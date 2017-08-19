//
//  OpenChatViewController.swift
//  firebaseTest
//
//  Created by hPark_ipl on 2017. 4. 28..
//  Copyright © 2017년 hPark. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var tableview: UITableView!
    
    var chatGroupVC: ChatGroupViewController?
    var userList: [User] = []
    
    func fetchUserList() {
        FirebaseDataService.instance.userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject>, let uid = FirebaseDataService.instance.currentUserUid {
                for (key, data) in data {
                    if uid != key {
                        if let userData = data as? Dictionary<String, AnyObject> {
                            let toUid = key
                            let username = userData["name"] as! String
                            let email = userData["email"] as! String
                            let user = User(uid: toUid, email: email, username: username)
                            self.userList.append(user)
                            
                            DispatchQueue.main.async(execute: { 
                                self.tableview.reloadData()
                            })
                        }
                    }
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        fetchUserList()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ref = FirebaseDataService.instance.groupRef.childByAutoId()
        ref.child("name").setValue(userList[indexPath.row].username as String)
        ref.updateChildValues(["name": userList[indexPath.row].username, "to": userList[indexPath.row].uid])
        dismiss(animated: true) { 
            if let chatGroupVC = self.chatGroupVC {
                chatGroupVC.performSegue(withIdentifier: "chatting", sender: ref.key)
            }
        }
        return
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        cell.textLabel?.text = userList[indexPath.row].username
        cell.detailTextLabel?.text = userList[indexPath.row].email
        return cell
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
