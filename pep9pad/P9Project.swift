//
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import CoreData

@objc(P9Project)    // Reveals this class to the Obj-C runtime.
class P9Project: NSManagedObject {
    // This class is used as the default storage object for P9P's source files.

    @NSManaged var source: String
    @NSManaged var object: String
    @NSManaged var listing: String
    @NSManaged var name: String
}
