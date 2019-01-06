//
//  ViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 2019-01-05.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import UIKit


class ViewController: UIViewController, TaskCallback {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonTapped(button: UIButton) {
        button.setTitle("Clicked!", for: UIControl.State.normal)

        let lt = LoginTask(callback: self, email: "email", password: "pass", gcap: "gcap")

        lt.execute()

    }

    func onCallBack(status: NetworkCallStatus) {

    }
}
