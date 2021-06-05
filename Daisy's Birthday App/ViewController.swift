//
//  ViewController.swift
//  Daisy's Birthday App
//
//  Created by Matt Benson on 03/06/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var WaitingMessage: UILabel!
    @IBOutlet weak var DaysLeftMessage: UILabel!
    @IBOutlet weak var DaysSinceStartMessage: UILabel!
    @IBOutlet weak var AgeMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Birth Date
        let dobStringDate = "2000-06-09"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateOfBirth = dateFormatter.date(from: dobStringDate)
        
//        Current Date
        let todaysDate = Date()
        let calendar = Calendar.current
        let yearsOldCompoments = calendar.dateComponents([.year], from: dateOfBirth ?? todaysDate, to: todaysDate)
        
        let today = calendar.startOfDay(for: Date())
        let date = calendar.startOfDay(for: dateOfBirth!)
        let dobCheckComponents = calendar.dateComponents([.day, .month], from: date)
        let nextDate = calendar.nextDate(after: today, matching: dobCheckComponents, matchingPolicy: .nextTimePreservingSmallerComponents)
        let daysUntilBirthday = calendar.dateComponents([.day], from: today, to: nextDate ?? today).day ?? 0

//        App Reveal Date Date
        let appRevealStringDate = "2021-06-09"
        let dateOfAppReveal = dateFormatter.date(from: appRevealStringDate)
        
        let daysFromAppReveal = calendar.dateComponents([.day], from: dateOfAppReveal!, to: (today ?? dateOfAppReveal)!).day ?? 0
        let daysFromAppRevealString = "\(daysFromAppReveal)"
        
//        Calculate age extension to fit the age
        var ageExtension = ""
        
        switch yearsOldCompoments.year! {
            case 1, 21, 31:
                ageExtension = "st"
            case 2, 22:
                ageExtension = "nd"
            case 3, 23:
                ageExtension = "rd"
            default:
                ageExtension = "th"
        }
                        
        var yearsOldString = ""
        
        DaysSinceStartMessage.text =  DaysSinceStartMessage.text?.replacingOccurrences(of: "{{days}}", with: daysFromAppRevealString)
        
        if(daysUntilBirthday == 365)  {
//            If today is the Birthday!!! 🥳
            Message.isHidden = false;
            AgeMessage.isHidden = false;
            WaitingMessage.isHidden = true;
            DaysLeftMessage.isHidden = true;
            
            yearsOldString = "\(yearsOldCompoments.year!)" + ageExtension.uppercased()
          
//            The Message and Age Replacement
            AgeMessage.text =  AgeMessage.text?.replacingOccurrences(of: "{{age}}", with: yearsOldString)
        } else {
//            Else if not the Birthday 🌚
            Message.isHidden = true;
            AgeMessage.isHidden = true;
            WaitingMessage.isHidden = false;
            DaysLeftMessage.isHidden = false;
            
            yearsOldString = "\(yearsOldCompoments.year!)" + ageExtension
            
            WaitingMessage.text =  WaitingMessage.text?.replacingOccurrences(of: "{{age}}", with: yearsOldString)
            
            WaitingMessage.text = WaitingMessage.text?.replacingOccurrences(of: "{{days}}", with: "\(daysUntilBirthday)")
            
            DaysLeftMessage.text = DaysLeftMessage.text?.replacingOccurrences(of: "{{days}}", with: "\(daysUntilBirthday)")
        }
    }
}

