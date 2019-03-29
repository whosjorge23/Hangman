//
//  ViewController.swift
//  Hangman
//
//  Created by Jorge Giannotta on 29/03/2019.
//  Copyright © 2019 Jorge Giannotta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var hangmanImage: UIImageView!
    
    @IBOutlet var letterButtons: [CornerRadiusView]!
    
    var lastButtonPressed: UIButton?
    
    override func viewWillAppear(_ animated: Bool) {
        updateWord()
    }
    
    @IBAction func letterButtonPressed(_ button: UIButton) {
        if button != lastButtonPressed {
            lastButtonPressed = button
        }
        lastButtonPressed?.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        var correct = false
        if let guess = lastButtonPressed?.titleLabel?.text {
            for subview in wordStackView.arrangedSubviews {
                if let label = subview as? UILabel {
                    if label.text == guess {
                        label.alpha = 1
                        correct = true
                    }
                }
            }
            if correct == false {
                wrongGuess()
            } else {
                lastButtonPressed?.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                lastButtonPressed?.isEnabled = false
                lastButtonPressed = nil
            }
        }
        if visibleCheck() {
            win()
        } else {
            if imageNumber == 7 {
                lose()
            }
        }
    }
    
    func visibleCheck() -> Bool {
        for subview in wordStackView.arrangedSubviews {
            if let label = subview as? UILabel {
                if label.alpha == 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func win() {
        hangmanImage.image = UIImage(named: "win-\(imageNumber)")
        updateWordButton.isHidden = false
        for button in letterButtons {
            button.isEnabled = false
        }
    }
    
    func lose() {
        hangmanImage.image = #imageLiteral(resourceName: "lose-1")
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.hangmanImage.image = #imageLiteral(resourceName: "lose-2")
            self.updateWordButton.isHidden = false
        })
        for button in letterButtons {
            button.isEnabled = false
        }
        for subview in wordStackView.arrangedSubviews {
            if let label = subview as? UILabel {
                label.alpha = 1
            }
        }
    }
    
    @IBAction func updateWordButtonPressed(_ sender: UIButton) {
        updateWord()
    }
    
    var imageNumber = 1
    
    func wrongGuess() {
        lastButtonPressed?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        lastButtonPressed?.isEnabled = false
        lastButtonPressed = nil
        imageNumber += 1
        hangmanImage.image = UIImage(named: "hangman-\(imageNumber)")
    }
    
    @IBOutlet weak var updateWordButton: CornerRadiusView!
    
    func updateWord() {
        
        func wordList() -> [String]? {
            guard let url = Bundle.main.url(forResource: "wordList", withExtension: "txt") else {
                return nil
            }
            let content = try! String(contentsOf: url)
            return content.components(separatedBy: "\n")
        }
        
        imageNumber = 1
        hangmanImage.image = #imageLiteral(resourceName: "hangman-1")
        for button in letterButtons {
            button.isEnabled = true
            button.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        }
        
        updateWordButton.isHidden = true
        
        guard let words = wordList() else { return }
        
        let randomIndex = Int(arc4random_uniform(UInt32((words.count))))
        var word = (words[randomIndex])
        
        //remove existing labels
        for label in wordStackView.arrangedSubviews {
            label.removeFromSuperview()
        }
        
        for underline in underlineStackView.arrangedSubviews {
            underline.removeFromSuperview()
        }
        
        let characters = Array(word.characters)
        for character in characters {
            let label = UILabel()
            label.text = String(character)
            label.font = UIFont.systemFont(ofSize: 24)
            label.textAlignment = .center
            label.textColor = .white
            label.alpha  = 0
            wordStackView.addArrangedSubview(label)
            
            label.widthAnchor.constraint(equalToConstant: 24).isActive = true
            label.layoutIfNeeded()
            
            let underline = UILabel()
            underline.text = "_"
            underline.font = UIFont.systemFont(ofSize: 45)
            underline.textAlignment = .center
            underline.textColor = .white
            underlineStackView.addArrangedSubview(underline)
            
            underline.widthAnchor.constraint(equalToConstant: 24).isActive = true
            underline.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var wordStackView: UIStackView!
    
    @IBOutlet weak var underlineStackView: UIStackView!
    
    
}


@IBDesignable
class CornerRadiusView : UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = -1
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
}
