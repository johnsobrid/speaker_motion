//
//  SettingsViewController.swift
//  speaker_motion
//
//  Created by Bridget Johnson on 22/06/15.
//  Copyright (c) 2015 bdj. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

   
   @IBOutlet var IPfield: UITextField!
   
   @IBOutlet var portField: UITextField!
   
   
   var ipString = String()
   var portString = String()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      ipString = "169.254.177.20"
      portString = "5558"
      IPfield.text = ipString
      portField.text = portString
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   @IBAction func connectPressed(sender: UIButton) {
      ipString = IPfield.text!
      portString = portField.text!
   }
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      if let identifier = segue.identifier {
         if identifier == "connect" {
            if let newVC = segue.destinationViewController as? GameViewController {
               newVC.manual_IP = ipString
               newVC.manual_Port = portString
            }
         }
      }
      
   }
}
