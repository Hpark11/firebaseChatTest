//
//  SignInViewController.swift
//  firebaseTest
//
//  Created by hPark_ipl on 2017. 4. 26..
//  Copyright © 2017년 hPark. All rights reserved.
//

//  "ran"
import UIKit

class SignInViewController: UIViewController {
    
    let chatViewController = ViewController()
    
    func openChattingView() {
        performSegue(withIdentifier: "chattingRooms", sender: nil)
    }
    
    @IBAction func johnButtonTapped(_ sender: UIButton) {
        FirebaseDataService.instance.signIn(email: "myEmail@naver.com", password: "123456789") {
            self.openChattingView()
        }
    }
    
    @IBAction func parkButtonTapped(_ sender: UIButton) {
        FirebaseDataService.instance.signIn(email: "yourEmail@naver.com", password: "123456789") { 
            self.openChattingView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
