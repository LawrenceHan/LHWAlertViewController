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
        let button: UIButton = UIButton(type: .system)
        button.setTitle("Show Alert", for: .normal)
        button.frame = CGRect(x: 100, y: 200, width: 100, height: 44)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showAlert(_ sender: UIButton) {
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
        let action = LHWAlertAction.action(title: "OK", style: .cancel, alignment: .justified, backgroundColor: nil, textColor: nil, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}

