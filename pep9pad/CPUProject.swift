//
//  pep9pad
//
//  Copyright © 2017 Pepperdine University. All rights reserved.
//

import CoreData

@objc(CPUEntity)    // Reveals this class to the Obj-C runtime.
class CPUEntity: NSManagedObject {
    // This class is used as the default storage object for P9CPU's source files.
    
    @NSManaged var source: String
    @NSManaged var name: String
}
