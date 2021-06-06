//
//  ViewController.swift
//  Daisy's Birthday App
//
//  Created by Matt Benson on 03/06/2021.
//

import UIKit
import SWXMLHash

class ViewController: UIViewController {

    @IBOutlet weak var Message: UILabel!
    @IBOutlet weak var WaitingMessage: UILabel!
    @IBOutlet weak var DaysLeftMessage: UILabel!
    @IBOutlet weak var DaysSinceStartMessage: UILabel!
    @IBOutlet weak var AgeMessage: UILabel!
    @IBOutlet weak var Quote: UILabel!
    @IBOutlet weak var RefreshQuote: UIButton!
    
    @IBAction func refreshQuote(_ sender: UIButton) {
//        API to get inspirational quote
        let inspirationalQuoteUrl = URL(string: "https://zenquotes.io/api/random");
            
        var inspirationalQuoteRequest = URLRequest(url:inspirationalQuoteUrl!)
        
        inspirationalQuoteRequest.httpMethod = "POST"
        
        let inspirationalQuoteTask = URLSession.shared.dataTask(with: inspirationalQuoteRequest) { data, response, error in
            guard let quoteData = data,
                let response = response as? HTTPURLResponse,
                error == nil else {                                              // check for fundamental networking error
                print("error", error ?? "Unknown error")
                return
            }

            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            let responseString = String(data: quoteData, encoding: .utf8)
            let tmpObject: AnyObject? = responseString as AnyObject
            
            if let _: AnyObject = tmpObject {
                DispatchQueue.main.async {
                    let responseJson = responseString!.data(using: .utf8)!
                    let json = try! JSONSerialization.jsonObject(with: responseJson)
                    
                    let results = json as! [[String:Any]]
                    for item in results {
                        self.Quote.text = "\(item["q"]!)" + " - " + "\(item["a"]!)"
                        
                    }
                }
            }
        }
        
        inspirationalQuoteTask.resume()
    }
    
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
            Quote.isHidden = true;
            RefreshQuote.isHidden = true;
            
            yearsOldString = "\(yearsOldCompoments.year!)" + ageExtension.uppercased()
          
//            The Message and Age Replacement
            AgeMessage.text =  AgeMessage.text?.replacingOccurrences(of: "{{age}}", with: yearsOldString)
        } else {
//            Else if not the Birthday 🌚
            Message.isHidden = true;
            AgeMessage.isHidden = true;
            WaitingMessage.isHidden = false;
            DaysLeftMessage.isHidden = false;
            Quote.isHidden = false;
            RefreshQuote.isHidden = false;
            
            yearsOldString = "\(yearsOldCompoments.year!)" + ageExtension
            
            WaitingMessage.text =  WaitingMessage.text?.replacingOccurrences(of: "{{age}}", with: yearsOldString)
            
            WaitingMessage.text = WaitingMessage.text?.replacingOccurrences(of: "{{days}}", with: "\(daysUntilBirthday)")
            
            DaysLeftMessage.text = DaysLeftMessage.text?.replacingOccurrences(of: "{{days}}", with: "\(daysUntilBirthday)")
            
//            API to get inspirational quote
            let inspirationalQuoteUrl = URL(string: "https://zenquotes.io/api/random");
//            let inspirationalQuoteUrl = URL(string: "AAAA");
                
            var inspirationalQuoteRequest = URLRequest(url:inspirationalQuoteUrl!)
            
            inspirationalQuoteRequest.httpMethod = "POST"
            
            let inspirationalQuoteTask = URLSession.shared.dataTask(with: inspirationalQuoteRequest) {
                data, response, error in
                
                guard let quoteData = data,
                    let response = response as? HTTPURLResponse,
                    error == nil else {                                              // check for fundamental networking error
                    print("error", error ?? "Unknown error")
                    return
                }

                guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                    print("statusCode should be 2xx, but is \(response.statusCode)")
                    print("response = \(response)")
                    return
                }
                
                let responseString = String(data: quoteData, encoding: .utf8)
                let tmpObject: AnyObject? = responseString as AnyObject
                
                if let _: AnyObject = tmpObject {
                    DispatchQueue.main.async {
                        let responseJson = responseString!.data(using: .utf8)!
                        let json = try! JSONSerialization.jsonObject(with: responseJson)
                        
                        let results = json as! [[String:Any]]
                        for item in results {
                            self.Quote.text = "\(item["q"]!)" + " - " + "\(item["a"]!)"
                            
                        }
                    }
                }
            }
            
            inspirationalQuoteTask.resume()
        }
    }
}
