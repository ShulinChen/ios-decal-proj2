//
//  ViewController.swift
//  Hangman
//
//  Created by Shulin Chen on 10/13/15.
//  Copyright © 2015 cs198-ios. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {
    //hangman figure
    @IBOutlet weak var head: UIView!
    @IBOutlet weak var leftArm: UIView!
    @IBOutlet weak var rightArm: UIView!
    @IBOutlet weak var body: UIView!
    @IBOutlet weak var leftLeg: UIView!
    @IBOutlet weak var rightLeg: UIView!
    
    //wordView for displaying the solution
    @IBOutlet weak var wordView: UIView!
    
    //keyboard
    @IBOutlet var keyboard: [UIButton]!

    var answer : String!
    var chanceLeft = 6
    var word = HangmanWords()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startGame(sender: AnyObject) {
        newGame()
    }
    
    
    @IBAction func keyboardPress(sender: UIButton) {
        
        var btn = sender
        btn.backgroundColor = UIColor.redColor()
        btn.enabled = false
        var selectedLetter : Character = Character(btn.titleLabel!.text!)
        
        if letterInWord(selectedLetter) {
            //check game status
            gameStatus()
        } else {
            chanceLeft -= 1
            //add body part and update the rest chances.
            showBody()
            gameStatus()
        }
    }
    
    //bunch of funcitons
    func newGame() {
        answer = word.getRandomWord()
        //todelete
        print(answer)
        chanceLeft = 6
        showBody()
        setButtons()
        setWordView()
        showKeyboard()
    }
    
    
    func showKeyboard() {
        for i in keyboard {
            i.hidden = false
        }
    }
    
    func hideKeyboard() {
        for i in keyboard {
            //print(i.titleLabel!.text!)
            i.hidden = true
        }
    }
    
    //helper function
    func letterInWord(selectedLetter: Character) -> Bool {
        var isLetterInWord = false
        var index = 0
        for solutionLetter in answer.characters {
            if solutionLetter == selectedLetter {
                isLetterInWord = true
                //reveal the letter in the view
                var lbl = wordView.subviews[index] as!  UILabel
                lbl.text = (String(selectedLetter))
            }
            index++
        }
        
        return isLetterInWord
    }
    
    func setWordView() {
        // remove existing view
        for label in wordView.subviews {
            label.removeFromSuperview()
        }
        
        //create the a label for each letter
        let numberOfLetters = answer.characters.count
        let totalWidth = wordView.bounds.width
        let availableSpaceForEachLetter = totalWidth / CGFloat(numberOfLetters)
        var xValue = wordView.bounds.origin.x
        for letter in answer.characters {
            var label = UILabel(frame: CGRectMake(xValue, wordView.bounds.origin.y, availableSpaceForEachLetter - 5, wordView.bounds.height))
            
            label.text = "?"
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "Arial", size: 50)
            label.backgroundColor = UIColor.lightGrayColor()
            wordView.addSubview(label)
            xValue += availableSpaceForEachLetter
        }
    }
    
    func showBody() {
        switch chanceLeft {
            case 5: self.head.hidden = false
            case 4: self.leftArm.hidden = false
            case 3: self.rightArm.hidden = false
            case 2: self.leftLeg.hidden = false
            case 1: self.rightLeg.hidden = false
            default:
                self.head.hidden = true
                self.leftArm.hidden = true
                self.rightArm.hidden = true
                self.leftLeg.hidden = true
                self.rightLeg.hidden = true
                self.body.hidden = true
        }
    }
    
    func setButtons() {
        for k in keyboard {
            k.enabled = true
            k.backgroundColor = UIColor.greenColor()
        }
    }
    
    func showAnswer() {
        var index = 0
        for solutionLetter in answer.characters {
            //reveal the letter in the view
            var lbl = wordView.subviews[index] as!  UILabel
            lbl.text = (String(solutionLetter))
            index++
        }
    }
    
    func gameStatus() {
        if chanceLeft == 1 {
            alert("Sorry you lose! Try again?")
            self.showAnswer()
        }
        
        var win = true
        //check guessed status so far
        for label in wordView.subviews {
            var labelView = label as? UILabel
            if labelView!.text == "?" {
                win = false
            }
        }
        if win {
            alert("Congratulations! You beat it! Another new game?")
        }
    }
    
    func alert(msg: String) {
        let alertController = UIAlertController(title: "Alert", message: msg, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            self.hideKeyboard()
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.newGame()
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
}

