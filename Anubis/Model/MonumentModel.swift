//
//  MonumentModel.swift
//  Anubis
//
//  Created by mahmoud mohamed on 3/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation

struct MonumentModel: Codable {
    
    var name: String!
    var lat: Double!
    var lon: Double!
    var imagesPaths: [String]!
    var tale: String!
}
