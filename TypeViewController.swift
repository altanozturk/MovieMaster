//
//  TypeViewController.swift
//  MovieMasterUpdated
//
//  Created by Altan OZTURK on 29.05.2022.
//

import UIKit

class TypeViewController: UIViewController {
    
    // I have int for save user informations which are in previous page.
    
    var aktarma : Int?
    var aktarma2 : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    

    @IBAction func actionButtonClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toQuestionVC", sender: nil)
    }
    
    
    
    // I send the informations to the next page.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toQuestionVC"{
            let destinationVC = segue.destination as! QuestionViewController
            destinationVC.sonIndex = aktarma
            destinationVC.sonScore = aktarma2
            
        }
    }
    
    
    
}
