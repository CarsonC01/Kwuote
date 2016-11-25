//
//  ViewController.swift
//  Kwuote
//
//  Created by Carson Carbery on 11/17/16.
//  Copyright © 2016 Carson Carbery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var quoteView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getQuote()
        addShadow()
        
        
        
    }

    func addShadow() {
        
        // Add shadow
        quoteView.layer.shadowOpacity = 0.5
        quoteView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        quoteView.layer.shadowRadius = 6.0

        
    }
    
    
    func getQuote() {
        
        let alert = Alert(presentingViewController: self)
        let quoteService = QuoteService(urlExtension: "quote")
        
        //HUD.show(.labeledProgress(title: "One sec dude", subtitle: "loading challenges..."))
        
        quoteService.getQuote() {
            
            (quote, result) in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    
                    print(quote)
                    
                    self.quoteLabel.text = "\"\(quote!.quoteText)\""
                    self.authorLabel.text = "- \(quote!.author)"
                    
                    //HUD.hide()
                    
                }
                
            case .failure(let error as NSError):
                DispatchQueue.main.async {
                    
                    //HUD.hide()
                    alert.popUpAlert(title: "Probable Time Out", message: "The following error occurred when attempting to retrieve Challenges \(error.localizedDescription)")
                    
//                    alert("Probable Time Out", message: "The following error occurred when attempting to retrieve Challenges \(error.localizedDescription)")
                    
                }
                
            default: alert.popUpAlert(title:"Errors Occurred", message: "The system was unable to retrieve challenges")
            //HUD.hide()
                
            }
            
        }

        
        
        
    }


}

