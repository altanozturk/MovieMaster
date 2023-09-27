//
//  QuestionViewController.swift
//  MovieMasterUpdated
//
//  Created by Altan OZTURK on 29.05.2022.
//

import UIKit
import Firebase


class QuestionViewController: UIViewController {
    
    
    @IBOutlet weak var questionTitleLabel: UILabel!
    @IBOutlet weak var questionContentLabel: UILabel!
    @IBOutlet weak var questionAnswerLabel: UITextField!
    
    // I have 3 arrays for questions
    // They stored all informations about questions.
    
    var questionContentArray = [String]()
    var questionAnswerArray = [String]()
    var questionNumberArray = [String]()
    
    // I have documentIdArray to check current user score and current question.
    
    var documentIdArray = [String]()
    
    // I have final user information variables.
    
    var sonIndex : Int?
    var sonScore : Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getQuestionDataFromFirestore()
        getUserDocumentID()
        

        
    }
    
    
    func getQuestionDataFromFirestore(){
        
        
        // Get question numbers from question collection in Firestore
        // Also take them with increasing question number
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("questions").order(by: "questionNumber", descending: false).addSnapshotListener { snapshot, error in
            if error != nil {
                
                print(error?.localizedDescription)
                
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    for document in snapshot!.documents{
                        
                        // Append question informations to the arrays
                        
                        if let questionAnswer = document.get("answer") as? String{
                            self.questionAnswerArray.append(questionAnswer)
                            
                            
                        }
                        
                        if let questionContent = document.get("content") as? String{
                            self.questionContentArray.append(questionContent)
                            
                        }
                        
                        if let questionNumber = document.get("questionNumber") as? String{
                            self.questionNumberArray.append(questionNumber)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    // Display question to the user
                    
                    self.questionTitleLabel.text = ((String(self.questionNumberArray[(self.sonScore ?? 0) - 1])))
                    self.questionContentLabel.text = (self.questionContentArray[(self.sonScore ?? 0) - 1])
                }
                
            }
            
            
            
        }
        
        
    }
    
  
    
    
    
    @IBAction func submitAnswerClicked(_ sender: Any) {
        
        // Check if the answer is true
        
        if questionAnswerArray[(self.sonScore ?? 0) - 1] == questionAnswerLabel.text{
            
           
            
            let fireStoreDatabase = Firestore.firestore()
            
                if let scoreCounter = Int(questionTitleLabel.text!){
                
                    // Create a variable which saves score as current score +1
                    
                let countStore = ["score" : scoreCounter + 1] as [String : Any]
                    
                    // Then put variable and change in the user collection information
                    
                fireStoreDatabase.collection("users").document(documentIdArray[self.sonIndex ?? 0]).setData(countStore, merge: true)
                
            }
                
            
            
            
            self.performSegue(withIdentifier: "toBackTypeVC", sender: nil)
            
          
            // If answer is wrong, display error message
            
        }else{
            
            let alert = UIAlertController(title: "False", message: "Wrong Answer", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
       
    }
    
    // To save current score of the user
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toBackTypeVC"{
            let destinationVC = segue.destination as! TypeViewController
            destinationVC.aktarma = sonIndex
            destinationVC.aktarma2 = sonScore
            
        }
    }
    
    
    // I take document ids to change user score value in submitAnswerClicked function
    
    func getUserDocumentID(){
        
        
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("users").addSnapshotListener { snapshot, error in
            if error != nil {
                
                print(error?.localizedDescription)
                
            } else {
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        
                  
                    }
        
        
    }
    

            }
        }
    }
   
    @IBAction func questionTypeMenuClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "toBackTypeVC", sender: nil)
        
        
    }
    

}
