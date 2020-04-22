//
//  Checklist.swift
//  Checklists
//
//  Created by mac on 4/21/20.
//  Copyright © 2020 ASD. All rights reserved.
//

import UIKit

class Checklist: NSObject , Codable
{
    var name = ""
    
    init(name : String)
    {
        self.name = name
        super.init()
    }
}
