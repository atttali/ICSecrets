//
//  ViewController.swift
//  ICSecrets
//
//  Created by Ali Attar on 24/02/2016.
//  Copyright © 2016 Ali Attar. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
  
  @IBOutlet weak var secretView: UITextView!
  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var button: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    nextButton.tag = 0
    
  }
  
  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  @IBAction func pressedButton(sender: AnyObject) {
    if (FBSDKAccessToken.currentAccessToken() != nil)
    {
      nextButton.tag = 0
      print("I'm logged in already!")
      printStuff(nextButton.tag)
    }
    else
    {
      let loginView : FBSDKLoginButton = FBSDKLoginButton()
      self.view.addSubview(loginView)
      loginView.center = CGPointMake(self.view.center.x, self.view.center.y + 80)
      loginView.readPermissions = ["public_profile", "email", "user_friends", "user_posts"]
      loginView.delegate = self
    }
    
  }
  
  
  @IBAction func next(sender: AnyObject) {
    nextButton.tag++
    printStuff(nextButton.tag)
  }
  
  func printStuff(number: Int) {
    var Request : FBSDKGraphRequest
    
   // print("\(FBSDKAccessToken.currentAccessToken())")
    
  //  var accessToken = String(format:"%@", FBSDKAccessToken.currentAccessToken().tokenString) as String
    
   // print("\(accessToken)")
    
    let parameters1 = ["access_token":FBSDKAccessToken.currentAccessToken().tokenString]
    
    
    Request  = FBSDKGraphRequest(graphPath:"ImperialCollegeSecrets/posts", parameters:parameters1, HTTPMethod:"GET")
    
    Request.startWithCompletionHandler({ (connection, result, error) -> Void in
      
     // MBProgressHUD.hideHUDForView(appDelegate.window, animated: true)
      
      if ((error) != nil)
      {
        print("Error: \(error)")
      }
      else
      {
      // print("Result: \(result)")
        
        let dataDict: AnyObject = result!.objectForKey("data")!
        let paging: AnyObject = result!.objectForKey("paging")!
        
        let num = number%25
        
//        print(dataDict[num]["message"])
        
        print(paging["next"])
        
        if let post = dataDict[num] as? [String: AnyObject] {
          if let message = post["message"] as? String {
              self.secretView.text = message
          }
        }
        
        
       // let strSecr = result!.objectForKey("message")!
       // print(strSecr)
      }
    })
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    print("User Logged In")
    if ((error) != nil)
    {
      // Process error
    }
    else if result.isCancelled {
      // Handle cancellations
    }
    else {
      // If you ask for multiple permissions at once, you
      // should check if specific permissions missing
      if result.grantedPermissions.contains("email")
      {
        // Do work
      }
    }
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }


}

