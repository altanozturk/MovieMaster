//
//  ScoreboardViewController.swift
//  MovieMasterUpdated
//
//  Created by Altan OZTURK on 29.05.2022.
//

import UIKit
import Firebase


class ScoreboardViewController: UIViewController {

    @IBOutlet weak var highscoreUserLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    // I have two arrays which contain email of the users and score of the users.
    
    var userEmailArray = [String]()
    var userScoreArray = [Int]()
    
    // I have two integer for save to current index of the scoreArray which is userScoreCurrent, and the score value of this index which is userScoreCurrent2
    
    var userScoreCurrent : Int?
    var userScoreCurrent2 : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        getUserDataFromFirestore()
        
        
    }
    

    
    @IBAction func playClicked(_ sender: Any) {
        
        var counter = 0
        
        for emails in userEmailArray{
            
            if emails == Auth.auth().currentUser?.email{
                
                print(emails)
                break
            }
            
            counter += 1
        }
        
        
        
        self.performSegue(withIdentifier: "toTypeVC", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTypeVC"{
            let destinationVC = segue.destination as! TypeViewController
            destinationVC.aktarma = userScoreCurrent
            destinationVC.aktarma2 = userScoreCurrent2
            
        }
    }
    
    
    
    
    func getUserDataFromFirestore(){
        
        // I take users from users collection in Firebase
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("users").addSnapshotListener { snapshot, error in
            if error != nil {
                
                print(error?.localizedDescription)
                
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    for document in snapshot!.documents{
                        
                        
                        // Append all user emails into the userEmailArray
                        
                        
                        
                        if let userEmail = document.get("email") as? String{
                            self.userEmailArray.append(userEmail)
                            
                            
                        }
                        
                        // Append all user scores into the userScoreArray
                        
                        if let userScore = document.get("score") as? Int{
                            self.userScoreArray.append(userScore)
                            
                        }
                        
                     
                    }
                    
                    // For obtain the highscore user, I have for loop
                    // .enumerated can help me to check indx value
                    
                    var counter1 = 0
                    var highscore = 0
                    for (indx,users) in self.userScoreArray.enumerated(){
                        
                        if users > highscore{
                            
                            highscore = users
                            counter1 = indx
                        }
                        
                        
                        
                    }
                    
                    // I print the texts of Highscore user
                    
                    self.highscoreUserLabel.text = ("Highscore user:  \(String(self.userEmailArray[counter1]))")
                    self.highscoreLabel.text = ("Score: \(String(highscore))")
                    
                    
                    // I take currentUser informations
                    // And saved in userScoreCurrent and userScoreCurrent2
                    // The reason of this, I have to pass this informations to the other screen.
                    
                    
                    var testEmail = Auth.auth().currentUser?.email
                    var ccounter = 0
                    for emails in self.userEmailArray{
                        
                        if testEmail == emails{
                            
                            break
                        }
                        
                        ccounter += 1
                        
                    }
                    
                    
                    self.userScoreCurrent = ccounter
                    self.userScoreCurrent2 = self.userScoreArray[ccounter]
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
    
    
    // User can sign out.
    
    @IBAction func signoutClicked(_ sender: Any) {
    
    
    
    do{
        try Auth.auth().signOut()
        self.performSegue(withIdentifier: "toBackVC", sender: nil)
        
        
    }catch{
        print("Error")
        
        
    }
    }
}
    
    



