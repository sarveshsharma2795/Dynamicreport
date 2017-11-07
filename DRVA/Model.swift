//
//  Model.swift
//  DRVA
//
//  Created by Sarvesh on 6/19/17.
//  Copyright © 2017 Sarvesh. All rights reserved.
//

import UIKit

class Model: UIViewController {
    var jsonforform = [["field-name" : "name", "type" : "text", "required" : "true","unique_id" : 1],["field-name":"age", "type":"number", "min":18, "max":65,"unique_id":2],["field-name":"address", "type":"multiline","unique_id":3], ["field-name":"gender", "type":"dropdown", "options":["Male", "Female","Other"],"unique_id":3]]
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

   }
