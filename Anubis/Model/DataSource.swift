//
//  DataSource.swift
//  Anubis
//
//  Created by mahmoud mohamed on 3/20/20.
//  Copyright © 2020 ASUFE. All rights reserved.
//

import Foundation
import CoreData.NSPersistentContainer

class DataSource {
    static let shared = DataSource()
    var persistentContainer: NSPersistentContainer!
    var viewContext: NSManagedObjectContext!
    var monuments: [MonumentModel] = []
    var savedMonuments: [Monument] = []
}
