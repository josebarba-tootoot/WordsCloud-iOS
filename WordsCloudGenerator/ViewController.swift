//
//  ViewController.swift
//  WordsCloudGenerator
//
//  Created by Jose Barba on 09/07/2020.
//  Copyright © 2020 Jose Barba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wordsCloud: WordsCloud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        wordsCloud.create(words: nil, frame: wordsCloud.frame)
    }
}

