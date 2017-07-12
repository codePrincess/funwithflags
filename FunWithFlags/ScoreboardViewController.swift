//
//  ScoreboardViewController.swift
//  FunWithFlags
//
//  Created by Manu Rink on 11.07.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import Foundation
import UIKit

class ScoreboardViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data : Array<Dictionary<String,String>>? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        data = UserDefaults.standard.value(forKey: "scores") as? Array<Dictionary<String,String>>
        
        data?.sort {
            first, second in
            
            let firstVal = Int(first["score"]!)
            let secVal = Int(second["score"]!)
            return firstVal! > secVal!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = data?.count {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scorecell", for: indexPath) as! ScoreboardCell
        
        let cellData = data?[indexPath.row]
        let username = cellData?["name"]
        let userscore = cellData?["score"]
        
        cell.userNameLabel?.text = username
        cell.userScoreLabel?.text = userscore
        cell.styleCell()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            data?.remove(at: indexPath.row)
            UserDefaults.standard.set(data, forKey: "scores")
            UserDefaults.standard.synchronize()
            
            tableView.reloadData()
        }
    }
    
}

class ScoreboardCell : UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var userShortLabel: UILabel!
    
    override func awakeFromNib() {}
    
    func styleCell() {
        let theString = userNameLabel?.text
        let firstCharIndex = theString?.index((theString?.startIndex)!, offsetBy: 1)
        userShortLabel?.text = userNameLabel?.text?.substring(to: firstCharIndex!)
        
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        drawUserCircle()
    }
    
    private func drawUserCircle () {
        UIGraphicsBeginImageContext(userImageView.frame.size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.randomColor(seed: userNameLabel.text!).cgColor)
        context?.fillEllipse(in: CGRect(origin: CGPoint(x: 0, y: 0) , size: CGSize(width: 60, height: 60)))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        userImageView.image = image
    }
    
}
