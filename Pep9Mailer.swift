//
//  Mailer.swift
//  pep9pad
//
//  Created by Josh Haug on 2/22/17.
//  Copyright © 2017 Pepperdine University. All rights reserved

import UIKit
import MessageUI

class Pep9Mailer: NSObject, MFMailComposeViewControllerDelegate {
    
    override init() {
        //prepare
    }
    

    

    
    func makeAlert() -> UIViewController {
        let mailCompose = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            mailCompose.addAttachmentData(projectModel.getData(ofType: ProjectContents.source), mimeType: "txt", fileName: projectModel.name.appending(".pep"))
            mailCompose.addAttachmentData(projectModel.getData(ofType: ProjectContents.object), mimeType: "txt", fileName: projectModel.name.appending(".pepo"))
            mailCompose.addAttachmentData(projectModel.getData(ofType: ProjectContents.listing), mimeType: "txt", fileName: projectModel.name.appending(".pepl"))
            return mailCompose
            
        } else {
            let mailAlert = UIAlertController(title: "Error", message: "Could not send mail.", preferredStyle: .alert)
            mailAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return mailAlert
        }
        
    }
    
    
    
    //MARK: Mail Composition
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([])
        mailComposerVC.setSubject("A Pep/9 Project \(projectModel.name)")
        mailComposerVC.setMessageBody("Here's a project from Pep/9.", isHTML: false)
        
        return mailComposerVC
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    


    
}
