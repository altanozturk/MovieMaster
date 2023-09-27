//
//  ViewController.swift
//  MovieMasterUpdated
//
//  Created by Altan OZTURK on 29.05.2022.
//

import UIKit
import Firebase


var scoreUser = 0


class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      
        
    }
    
    

    
    @IBAction func signInClicked(_ sender: Any) {
        
        // Check if email or password is empty
        
        if emailText.text != "" && passwordText.text != ""{
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                
                if error != nil{
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                }else{
                    
                
                    
                    
                    self.performSegue(withIdentifier: "toScoreboardVC", sender: nil)
                    
                }
            }
            
            
        // If email or password is empty, display error message
            
        }else{
            makeAlert(titleInput: "Error", messageInput: "Username/Password?")
            
            
        }
                
        
        
    }
    
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        
        // Check if email or password is empty
        
        if emailText.text != "" && passwordText.text != ""{
            
          
            
            // Save user for createUser function of Swift.
            // Take currentUser.email function from Swift and save with a variable.
            // Set score as 1 when a new user created
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                }else{
                    
                    
                    let firestoreDatabase = Firestore.firestore()
                    
                    var firestoreReference : DocumentReference? = nil
                    
                    let firestoreUser = ["email" : Auth.auth().currentUser!.email!,"score" : 1] as [String : Any]
                    
                    firestoreReference = firestoreDatabase.collection("users").addDocument(data: firestoreUser, completion: { (error) in
                        if error != nil{
                            
                            self.makeAlert(titleInput: "Error", messageInput: "Error")
                            
                        }
                        
                        scoreUser = firestoreUser["score"] as! Int 
                        
                    })
                    
                 
                    
                    self.performSegue(withIdentifier: "toScoreboardVC", sender: nil)
                    
                }
            }
            
           // If email or password is empty, display error message
            
        } else {
            
            makeAlert(titleInput: "Error!", messageInput: "Username/Password?")
            
        }
        
    }
    
    // For display messages, I create a makeAlert function.
    // This function takes two arguments such as titleInput and messageInput for displaying error message which we want
    
    func makeAlert(titleInput : String , messageInput : String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    


}

