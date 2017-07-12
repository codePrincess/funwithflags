//
//  ScoreViewController.swift
//  FunWithFlags
//
//  Created by Manu Rink on 11.07.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var userScore : Int = 0
    var userName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextfield.delegate = self
        scrollview.contentSize = CGSize(width: scrollview.contentSize.width, height: scrollview.contentSize.height+300)
        scoreLabel.text = "\(userScore)"
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollview.scrollRectToVisible(nameTextfield.frame, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName = textField.text!
        textField.resignFirstResponder()
        
        if !userName.isEmpty {
            saveScore()
        }
        
        navigationController?.popToRootViewController(animated: true)
        
        return true
    }
    
    func saveScore() {
        
        var duplUser = false
        
        var results = UserDefaults.standard.value(forKey: "scores") as? Array<Dictionary<String,String>>
        if  let scoreResults = results {
            for score in scoreResults {
                if score["name"] == userName {
                    let alertController = UIAlertController(title: "Upsi!", message: "User already exists 🙃", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    duplUser = true
                    break
                }
            }
        } else {
            UserDefaults.standard.set(Array<Dictionary<String,String>>(), forKey: "scores")
            results = UserDefaults.standard.value(forKey: "scores") as? Array<Dictionary<String,String>>
        }
        
        if !duplUser {
            var dict = Dictionary<String, String>()
            dict["name"] = userName
            dict["score"] = String(userScore)
            results?.append(dict)
            UserDefaults.standard.set(results, forKey: "scores")
            UserDefaults.standard.synchronize()
        }
        
    }
    
    @IBAction func backToMenuPressed(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
