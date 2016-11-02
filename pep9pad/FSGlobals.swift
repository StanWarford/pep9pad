//
//  FSGlobals.swift
//  pep9pad
//
//  Created by Josh Haug on 10/31/16.
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import UIKit
import CoreData



let FSEntityName = "FSEntity"
typealias FSFileType = (name:String, type:String, source:String)




// MARK: - Defaults

let NumDefaultFiles: Int = 1

var DefaultFiles: Array<FSFileType> = [
    (name:"My First Program", type: PepFileType.pep.rawValue, source: getStringFromDefaultFile(fileName: "myFirstProgram", ofType: PepFileType.pep))
]


/// Only called from AppDelegate, and only called when `isFirstLaunch` is true.
/// i.e. happens only once, on the first launch following an installation.
/// Adds all elements of `DefaultFiles` to the CoreDatabase
func setupFS() {
    
    let appDel: AppDelegate =  UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext
    
    var idx = 0
    for defaultFile in DefaultFiles {
        let ent = NSEntityDescription.entity(forEntityName: FSEntityName, in: context)
        let newFile = FSEntity(entity: ent!, insertInto: context)
        newFile.name = defaultFile.name
        newFile.type = defaultFile.type
        newFile.source = defaultFile.source
        idx += 1
        do {
            try context.save()
        } catch {
            print("Unknown Error")
        }
    }
}

func getStringFromDefaultFile(fileName: String, ofType: PepFileType) -> String {
    guard let path = Bundle.main.path(forResource: fileName, ofType: ofType.rawValue) else {
        print("Could not load file named \(fileName).\(ofType.rawValue)")
        return ""
    }

    do {
        let content = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
        print("Loaded file named \(fileName).\(ofType.rawValue)")
       return content
        
    } catch _ as NSError {
        print("Could not load file named \(fileName).\(ofType.rawValue)")
        return ""
    }
}



// MARK: - Loading, Removing, and Adding Objects

// I'm not sure we want to do this -- source Strings are going to be large and should only be loaded when needed.
//func loadFilesFromFS() {
//    
//    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context: NSManagedObjectContext = appDel.managedObjectContext
//    
//    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequest.entity = NSEntityDescription.entity(forEntityName: FSEntityName, in: context)
//    fetchRequest.includesPropertyValues = false
//    
//    do {
//        
//        if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
//            for result in results {
//                // cast it first:
//                let res = result as! FSEntity
//                
//                let tempName: String = res.name
//                let tempType: String = res.type
//                let tempSource: String = res.source
//                
//                KnownWaves.append((name: res.nameOfWave, force: res.sourceString, y0: res.y0, v0: res.v0,  a: aLocal, b: bLocal, c: cLocal, d: dLocal, tFinal: res.tFinal, amp: ampLocal))
//                
//            }
//        }
//    } catch {
//        print("Error in loading files from FS.")
//    }
//
//}



//func removeAllFilesFromCoreData() {
//    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//    let context: NSManagedObjectContext = appDel.managedObjectContext!
//    
//    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
//    fetchRequest.entity = NSEntityDescription.entity(forEntityName: FSEntityName, in: context)
//    fetchRequest.includesPropertyValues = false
//    do {
//        if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
//            for result in results {
//                context.delete(result)
//            }
//            try context.save()
//            // do something after save
//        }
//    } catch SetupError.knownError {
//        print("Known Error")
//    } catch {
//        print("Unknown Error")
//    }
//}



func loadFileNamesFromFS() -> [String] {
    
    var names: [String] = []
    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: FSEntityName, in: context)
    fetchRequest.includesPropertyValues = false

    do {

        if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
            for result in results {
                // cast it first:
                let res = result as! FSEntity
                names.append(res.name)
            }
        }
    } catch {
        print("Error in loading file names from FS.")
    }
    
    return names

}


func loadFileFromFS(named n: String) -> FSEntity? {
    
    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let context: NSManagedObjectContext = appDel.managedObjectContext
    
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: FSEntityName, in: context)
    fetchRequest.includesPropertyValues = false
    
    do {
        
        if let results = try context.fetch(fetchRequest) as? [NSManagedObject] {
            for result in results {
                let res = result as! FSEntity
                if res.name == n {
                    return res
                }
            }
        }
    } catch {
        print("Error in loading file names from FS.")
    }
    
    return nil

}





