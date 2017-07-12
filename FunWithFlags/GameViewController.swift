//
//  GameViewController.swift
//  FunWithFlags
//
//  Created by Manu Rink on 11.07.17.
//  Copyright © 2017 microsoft. All rights reserved.
//

import Foundation
import UIKit
import GameplayKit



class GameViewController : UIViewController {
    
    var allCountryNames = [String]()
    var countryNames = [String]()
    var countriesArray = Array<Dictionary<String,String>>()
    
    var currentCountryName : String = ""
    var gameScore : Int = 0
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet var answerButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleComponents()
        loadAllCountries()
        loadQuestions()
        
        showQuestion(index: 0)
    }
    
    private func styleComponents () {
        flagImageView.layer.shadowRadius = 5
        flagImageView.layer.shadowColor = UIColor.lightGray.cgColor
        flagImageView.layer.shadowOpacity = 0.9
        
        for btn in answerButtons {
            btn.layer.cornerRadius = 5
        }
    }
    
    private func loadAllCountries () {
        let countriesFile = Bundle.main.path(forResource: "allCountries", ofType: "json")
        let theData = NSData.init(contentsOfFile: countriesFile!)
        let countries = try? JSONSerialization.jsonObject(with: theData! as Data, options: []) as! Array<Dictionary<String,String>>
        
        for country in countries! {
            let theCountry = country["name"]
            allCountryNames.append(theCountry!)
        }
    }
    
    private func loadQuestions() {
        
        //data already loaded
        if countryNames.count > 0 {
            return
        }
        
        let countriesFile = Bundle.main.path(forResource: "countries", ofType: "json")
        let theData = NSData.init(contentsOfFile: countriesFile!)
        let countries = try? JSONSerialization.jsonObject(with: theData! as Data, options: []) as! Dictionary<String,Any>
        
        countriesArray = countries?["questions"] as! Array<Dictionary<String,String>>
        
        for country in countriesArray {
            let theCountry = country["countryLong"]
            countryNames.append(theCountry!)
        }
    }
    
    

    func showQuestion (index: Int) {
        let countryRandom = GKRandomDistribution(lowestValue: 0, highestValue: allCountryNames.count-1)
        let buttonRandom = GKRandomDistribution(lowestValue: 0, highestValue: 3)
        
        let country = countriesArray[index]
        flagImageView.image = UIImage(named: country["countryShort"]!)
            
        let randButton = buttonRandom.nextInt()
        let questionName = country["countryLong"]
        answerButtons[randButton].setTitle(questionName, for: .normal)
        currentCountryName = questionName!
        
        var checkDuplicates = Array<Int>()
        for i in 0...3 {
            if i != randButton {
                var randCountry = countryRandom.nextInt()
                
                while checkDuplicates.contains(randCountry) {
                    randCountry = countryRandom.nextInt()
                }
                
                let countryName = allCountryNames[randCountry]
                answerButtons[i].setTitle(countryName, for: .normal)
                checkDuplicates.append(randCountry)
            }
        }
        
        countriesArray.remove(at: index)
    }
    
    private func fadeOut() {
        UIView.animate(withDuration: 0.3) { 
            self.flagImageView.alpha = 0.5
            for btn in self.answerButtons {
                btn.alpha = 0.5
            }
        }
    }
    
    private func fadeIn() {
        UIView.animate(withDuration: 0.3) {
            self.flagImageView.alpha = 1
            for btn in self.answerButtons {
                btn.alpha = 1
            }
        }
    }
    
    @IBAction func answerButtonPressed(_ sender: Any) {
        let button = sender as! UIButton
        if button.title(for: .normal) == currentCountryName {
            currentCountryName = ""
            gameScore += 1
        }
        
        if countriesArray.count < 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "userScoreVC") as! ScoreViewController
            vc.userScore = gameScore
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let questionRandom = GKRandomDistribution(lowestValue: 0, highestValue: countriesArray.count-1)
            fadeOut()
            showQuestion(index: questionRandom.nextInt())
            fadeIn()
        }
    }
    
    
}
