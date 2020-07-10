//
//  ViewController.swift
//  WordsCloudGenerator
//
//  Created by Jose Barba on 09/07/2020.
//  Copyright © 2020 Jose Barba. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var viewContainer: WordsCloud!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewContainer.create(words: nil, frame: viewContainer.frame)
        viewContainer.delegate = self
        
    }
}

extension ViewController: WordsCloudDelegate {
    func didTap(onWord word: String, index: Int) {
        // Do something
    }
}

