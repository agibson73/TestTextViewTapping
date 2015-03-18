//
//  ViewController.swift
//  TestTextViewTapping
//
//  Created by Alex Gibson
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    
    let phrases = NSArray(array: ["I love programming in Swift", "Swift can be difficult sometimes and easy others","Swiftly learn Swift", "Swift Optionals are interesting", "Let's see if Swift can be swift"])
    
    let colors = NSArray(array: [UIColor.lightGrayColor(),UIColor.brownColor(),UIColor.greenColor()])
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.textView.textContainer.lineFragmentPadding = 0
        self.textView.textContainerInset = UIEdgeInsetsZero
       
        // make the textView clear
        self.textView.backgroundColor = UIColor.clearColor()
        
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "textViewTapped:")
        self.textView.addGestureRecognizer(tap)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextPhraseDidPress(sender: UIButton) {
        
        //reset count if
        println("\(count)")
        if count == self.phrases.count-1{
           count = 0
        }
        else
        {
            self.count = count + 1
        }
        
        //call method to set text
        self.setTextViewText()
 
    }
    
    func setTextViewText(){
        
        let phrase = phrases[count] as String
        
        if let range = self.rangeIfSwiftInString(phrase, find: "swift"){
            
            
            
            // attributed text for social label
            // create attributed text to set our category images
            
            let fontTopColor : UIColor = UIColor.grayColor()
            let swiftColor = UIColor.redColor()
            
            let font = UIFont(name: "AvenirNext-Regular", size: 15)
            
            var stringToAttribute = phrase
            
            let attributedString = NSMutableAttributedString(string:stringToAttribute,attributes:
                [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontTopColor])
            
            // make swift red
            attributedString.addAttribute(NSForegroundColorAttributeName, value: swiftColor, range: range)
            
            // set our label
            textView.attributedText = attributedString
            textView.textAlignment = NSTextAlignment.Center
            
        }
        else{
            
            //no swift
            let fontTopColor : UIColor = UIColor.grayColor()
            let font = UIFont(name: "AvenirNext-Regular", size: 15)
            var stringToAttribute = phrase
            
            let attributedString = NSMutableAttributedString(string:stringToAttribute,attributes:
                [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontTopColor])
            
            
            // set our label
            textView.attributedText = attributedString
            textView.textAlignment = NSTextAlignment.Center
            
            
        }
        
    }
    
    
    func rangeIfSwiftInString(str : String , find : String)->NSRange?{
        
        // may be optional
        var rangeOfSwift : NSRange?
        
        // may be best if you want it to not be case sensitive
        if str.lowercaseString.rangeOfString(find) != nil {
            println("exists")
            
            // find the range and print
            let stringAsNSString = str.lowercaseString as NSString
            let textRange = NSMakeRange(0, stringAsNSString.length)

            stringAsNSString.enumerateSubstringsInRange(textRange, options: NSStringEnumerationOptions.ByWords, usingBlock: { substring, subStringRange, enclosingRange, stop in
                
                if substring == find{
                    println("\(subStringRange)")
                    // call tap method
                    rangeOfSwift = subStringRange
                    
                }
                
                
            })
        }
        
        // remember to check for optional
        return rangeOfSwift
        
    }
    
    
    
    func textViewTapped(sender:UITapGestureRecognizer){
        
        let phrase = phrases[count] as String
        
        if let rangeOfSwift = self.rangeIfSwiftInString(phrase, find: "swift"){
            
        
        
        let textView = sender.view as UITextView
        let layoutManager = textView.layoutManager
        let location = sender.locationInView(textView)
        var characterIndex : Int!
        characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if (characterIndex < textView.textStorage.length) {
            // valid index
            // Find the word range here
            // using -enumerateSubstringsInRange:options:usingBlock:
            
            
            var range = NSRange(location: 0, length: 0)
            
            var attributes = textView.textStorage.attributesAtIndex(characterIndex, effectiveRange: &range)
            
            // need to find a better way than to hardcode
            if range.location == rangeOfSwift.location && range.length == rangeOfSwift.length{
                
                // attributed text for social label
                // create attributed text to set our category images
                
                let fontTopColor : UIColor = UIColor.grayColor()
                let swiftColor = UIColor.greenColor()
                
                let font = UIFont(name: "AvenirNext-Regular", size: 15)
                
                // have to use carriage return for two lines
                var stringToAttri = phrase
                
                
                let topAttri = NSMutableAttributedString(string:stringToAttri,attributes:
                    [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontTopColor])
                
                // make swift blink green
                topAttri.addAttribute(NSForegroundColorAttributeName, value: swiftColor, range: rangeOfSwift)
                
                // set our label
                textView.attributedText = topAttri
                textView.textAlignment = NSTextAlignment.Center
                
                
                // perform delay and change back
                self.delay(0.20, closure: {
                   
                    self.animateViewColor()
                    self.resetCurrentText(phrase, rangeOfSwift: rangeOfSwift)
                    
                    
                })
                
                
            }
            
        }
        
        }
        else
        {
            println("Swift Not tapped")
        }
    }
    
    
    // this is an awesome way to perform a delay when calling a function
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func resetCurrentText(currentText : String, rangeOfSwift : NSRange){
        
        let stringToAttri = currentText
        // attributed text for social label
        // create attributed text to set our category images
        
        let fontTopColor : UIColor = UIColor.grayColor()
        let swiftColor = UIColor.redColor()
        
        let font = UIFont(name: "AvenirNext-Regular", size: 15)
        // reset the string
        let topAttri = NSMutableAttributedString(string:stringToAttri,attributes:
            [NSFontAttributeName: font!, NSForegroundColorAttributeName: fontTopColor])
        // make swift red again
        topAttri.addAttribute(NSForegroundColorAttributeName, value: swiftColor, range: rangeOfSwift)
        
        // set our label
        textView.attributedText = topAttri
        textView.textAlignment = NSTextAlignment.Center
    }
    
    func animateViewColor(){
        UIView.animateWithDuration(1, animations: {
            
            for color in self.colors
            {
                let col = color as UIColor
                self.view.backgroundColor = col
                var random = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
                self.view.alpha = random
            }
            
            
            }, completion: { finished in
                
                // view white again.
                UIView.animateWithDuration(0.3, animations: {
                    self.view.backgroundColor = UIColor.whiteColor()
                    self.view.alpha = 1
                })
                
        })
        

    }


}

