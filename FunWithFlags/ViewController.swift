//
//  ViewController.swift
//  FunWithFlags
//
//  Created by Manu Rink on 11.07.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var highscoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        styleButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func styleButtons() {
        startGameButton.layer.cornerRadius = 5
        highscoreButton.layer.cornerRadius = 5
    }


}

