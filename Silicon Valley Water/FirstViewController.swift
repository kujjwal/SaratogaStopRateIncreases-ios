//
//  FirstViewController.swift
//  Silicon Valley Water
//
//  Created by Ujjwal Krishnamurthi on 7/24/18.
//  Copyright © 2018 Ujjwal Krishnamurthi. All rights reserved.
//

import UIKit
import SafariServices
import MessageUI

class FirstViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var send_email: UIButton!
    
    var details_str: String = "";
    var summary_str: String = "";
    var success_str: String = "";
    var email_send_str: String = "";
    var to_str: String = "";
    var cc_str: String = "";
    var subject_str: String = "";
    var completed: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        send_email.titleLabel?.textAlignment = .center;
        send_email.layer.cornerRadius = 25;
        
        name.delegate = self;
        email.delegate = self;
        address.delegate = self;
        
        getData();
        
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
        let urlString: String = "https://docs.google.com/feeds/download/documents/export/Export?id=1vPdvH2dQYoayrS0xgfxToIBsBS0cTAUAp-Hj1M2TMAw&exportFormat=txt";
        let url = URL(string: urlString);
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!);
            let total: String = String(data: data!, encoding: String.Encoding.utf8)!;
            
            self.success_str = total[self.indexOf(total: total, search: "SUCCESS") + 7..<self.indexOf(total: total, search: "DETAILS TO COPY, PASTE")].trim();
            self.email_send_str = total[self.indexOf(total: total, search: "Dear PUC")..<self.indexOf(total: total, search: "cumulative rate changes.") + 24] + "\n" + total[self.indexOf(total: total, search: "AL 510: WE WANT MORE")..<self.indexOf(total: total, search: "gouging of the consumer.") + 24] + "\n" + total[self.indexOf(total: total, search: "In my opinion, SJWC")..<self.indexOf(total: total, search: "END EMAIL")].trim();
            
            self.details_str = self.email_send_str[0..<self.indexOf(total: self.email_send_str, search: "Sincerely,")].trim();
            self.summary_str = total[self.indexOf(total: total, search: "SUMMARY") + 18..<self.indexOf(total: total, search: "SUCCESS")].trim();
            
            self.to_str = total[self.indexOf(total: total, search: "EMAIL:") + 6..<self.indexOf(total: total, search: "CC:")].trim();
            self.cc_str = total[self.indexOf(total: total, search: "CC:") + 3..<self.indexOf(total: total, search: "SUBJECT:")].trim();
            self.subject_str = total[self.indexOf(total: total, search: "SUBJECT:")..<self.indexOf(total: total, search: "Dear PUC President Picker and Commissioners,")].trim();
            
            let second = self.tabBarController?.viewControllers![1] as! SecondViewController;
            second.summary_str = self.summary_str;
            second.details_str = self.details_str;
            
            self.completed = true;
        }
    }
    
    func indexOf(total: String, search: String) -> Int {
        if let range = total.range(of: search) {
            let startPos = total.distance(from: total.startIndex, to: range.lowerBound)
            _ = total.distance(from: total.startIndex, to: range.upperBound)
            return startPos;
        } else {
            return -1;
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if(self.completed) {
            let b: Bool = self.isEmail(email: email.text!);
            let c: Bool = !address.text!.trim().isEmpty;
            let a: Bool = !name.text!.trim().isEmpty;
            if(!a) {
                self.textAlert(title: "Name", msg: "Fill In Name Field Correctly.");
            } else if(!b) {
                self.textAlert(title: "Email", msg: "Fill In Email Field Correctly.");
            } else if(!c) {
                self.textAlert(title: "Address", msg: "Fill In Address Field Correctly.");
            } else {
                // Send email
                let to_arr: [String] = to_str.components(separatedBy: ",");
                let cc_arr: [String] = cc_str.components(separatedBy: ",");
                self.email_send_str = self.email_send_str.replacingOccurrences(of: "Your Name", with: self.name.text!);
                self.email_send_str = self.email_send_str.replacingOccurrences(of: "Address", with: self.address.text!);
                let text_f: String = details_str + "\n\nRegards,\n" + name.text! + "\n" + email.text! + "\n" + address.text! + "\n";
                self.sendEmailTo(to: to_arr, cc: cc_arr, bcc: [email.text!], subject: subject_str, text: text_f);
            }
        }
    }
    @IBAction func councilmember_button(_ sender: UIButton) {
        let b: Bool = self.isEmail(email: email.text!);
        if(!b) {
            self.textAlert(title: "Email", msg: "Fill In Email Field Correctly.");
        } else {
            self.sendEmailTo(to: ["rkumar@saratoga.ca.us"], bcc: [email.text!], subject: "Saratoga Water App FAQ", text: "Question: ");
        }
    }
    
    func sendEmailTo(to: [String], cc: [String]? = nil, bcc: [String], subject: String, text: String) -> Void {
        let no_cc: Bool = cc == nil || cc!.count == 0;
        
        let composeVC = MFMailComposeViewController();
        composeVC.mailComposeDelegate = self;
        composeVC.setToRecipients(to);
        composeVC.setBccRecipients(bcc);
        if(!no_cc) {
            composeVC.setCcRecipients(cc);
        }
        composeVC.setSubject(subject);
        composeVC.setMessageBody(text, isHTML: false);
        
        self.present(composeVC, animated: true, completion: nil);
    }
    
    func isEmail(email: String) -> Bool{
        let pat = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        let regex = try! NSRegularExpression(pattern: pat, options: []);
        let matches = regex.matches(in: email, options: [], range: NSRange(location: 0, length: email.count))
        return matches.count > 0;
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: {
            self.success_alert();
        });
    }
    
    func textAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert);
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in });
        alert.addAction(cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    func success_alert() {
        let alert = UIAlertController(title:"Success!", message:success_str, preferredStyle:.alert);
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in });
        
        let attributedString = NSMutableAttributedString(string: success_str)
        attributedString.addAttribute(.link, value: "http://www.tinyurl.com/noMoreSJWC", range: NSRange(location: self.indexOf(total: success_str, search: "http://tinyurl.com/nomoreSJWC") + 6, length: "http://tinyurl.com/nomoreSJWC".count));
        alert.setValue(attributedString, forKey: "attributedMessage");
        let hyperlink = UIAlertAction(title: "Go to Petition", style: .default, handler: {(action) -> Void in
            let url = URL(string: "http://www.tinyurl.com/noMoreSJWC");
            if(UIApplication.shared.canOpenURL(url!)) {
                UIApplication.shared.open(url!);
            }
        });
        
        alert.addAction(hyperlink);
        alert.addAction(cancel);
        self.present(alert, animated: true, completion: nil);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    func trim() -> String
    {
        return self.trimmingCharacters(in: .whitespacesAndNewlines);
    }
}
