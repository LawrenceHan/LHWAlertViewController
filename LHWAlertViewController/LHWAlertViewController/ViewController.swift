//
//  ViewController.swift
//  LHWAlertViewController
//
//  Created by Hanguang on 28/03/2017.
//  Copyright © 2017 Hanguang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let alert = LHWAlertViewController.alertController(
            title: "Title",
            message: "Message",
            textAlignment: .justified,
            preferredStyle: .alert,
            headerView: nil,
            footerView: nil) { isBackgroundTapped in
                if isBackgroundTapped {
                    print("alert background tapped")
                }
        }
        
        alert.backgroundStyle = .plain
        alert.shouldDismissOnBackgroundTap = true
        
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

