//
//  ThirdViewController.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 7/24/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import UIKit
import MessageUI

class ThirdViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button1.layer.cornerRadius = 10;
        button2.layer.cornerRadius = 10;
        button3.layer.cornerRadius = 10;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func sjwcf(_ sender: Any) {
        self.openUrl(url: "https://www.sjwater.com/customer-care/help-information/filings-cpuc");
    }
    
    @IBAction func cpucph(_ sender: Any) {
        self.openUrl(url: "http://www.cpuc.ca.gov/Events/");
    }
    
    @IBAction func wdm(_ sender: UIButton) {
        self.openUrl(url: "https://scvwd.legistar.com/Calendar.aspx");
    }
    
    
    @IBAction func council_action(_ sender: UIButton) {
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
    
    func openUrl(url:String!) {
        let url = URL(string: url);
        if(UIApplication.shared.canOpenURL(url!)) {
            UIApplication.shared.open(url!);
        }
    }
}
