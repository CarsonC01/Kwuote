//
//  Alert.swift
//  Kwuote
//
//  Created by Carson Carbery on 11/17/16.
//  Copyright © 2016 Carson Carbery. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    private let presentingViewController: UIViewController
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
    }
    
    // PRESENT ALERT METHOD
    
    func popUpAlert(title: String, message: String) {
        
        //        let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: {(action: UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
            print("Taking user back to view before alert")
            
        }))
        presentingViewController.present(alert, animated: true, completion: nil)
        
    }
    
}
