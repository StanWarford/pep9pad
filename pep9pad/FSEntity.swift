//
//  FSEntity.swift
//  pep9pad
//
//  Created by Josh Haug on 10/31/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import CoreData

@objc(FSEntity)    // Reveals this class to the Obj-C runtime.
class FSEntity: NSManagedObject {
    // This class is used as the default storage object for P9P's source files.

    @NSManaged var source: String
    @NSManaged var object: String
    @NSManaged var listing: String
    @NSManaged var name: String
}
