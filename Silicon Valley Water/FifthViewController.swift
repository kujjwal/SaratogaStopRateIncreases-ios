//
//  FifthViewController.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 8/2/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class FifthViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var councilmember: UIButton!
    @IBOutlet weak var imgEnd: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + (13/24) * imgEnd.frame.height);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func councilmember(_ sender: UIButton) {
        self.sendEmailTo(to: ["rkumar@saratoga.ca.us"], subject: "Saratoga Water App FAQ", text: "Question: ");
    }
    
    func sendEmailTo(to: [String], subject: String, text: String) -> Void {
        let composeVC = MFMailComposeViewController();
        composeVC.mailComposeDelegate = self;
        composeVC.setToRecipients(to);
        composeVC.setSubject(subject);
        composeVC.setMessageBody(text, isHTML: false);
        
        self.present(composeVC, animated: true, completion: nil);
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil);
    }
}
