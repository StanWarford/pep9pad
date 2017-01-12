
//  Notes.swift
//  Created by Josh Haug on 4/24/15.

import UIKit





// ----------------------- DECLARING VARIABLES ---------------------------
// Variables are declared with `var`.
var introduction: String = "Hello, World!"
// Constants are declared with `let`.
let languageName: String = "Swift"

// The colon is the type operator in Swift.
// Anytime you see a colon, read it as "of type".
// There is one exception which will be covered later.

var version: Double = 1.0
var versionWithoutType = 1.0
// don't need to specify types!

let someString = "I appear to be a string."
// inferred to have type String

// semicolons are allowed but neither required nor recommended
let c: Int = 7;
let d: Double = 7.0

// multiple declarations on one line
let a = 3, b = 5

// String intepolation works like this:
let mathResult = "\(a) times \(b) is \(a * b)"
// "3 times 5 is 15"






// --------------------- COLLECTION TYPES ---------------------------------
var names = ["Anna", "Alex", "Miguel", "John"]
// an array
// we can flag this array as being "Strings only" like this:
var names2: [String] = ["Anna", "Alex", "Miguel", "John"]
// We say [String] which is the same as String[]
// But Swift will infer that names is of type String[], so we don't even have to specify

var numberOfLegs = ["ant": 6, "snake": 0, "cheetah": 4]
// a dictionary







// ------------------------- LOOPS -------------------------------------------

// while and do-while (called repeat-while) loops behave like you'd expect.

var sated = true

while !sated {
    // do something
}

repeat {
    // do something
} while !sated

// An interesting aspect of Swift is that parens are not needed for test cases.
// That said, the compiler will still accept a test case enclosed in parentheses.


// This C-style loop is no longer supported as of Swift 3.
//      for apostleCount = 1; apostleCount <= 12; apostleCount++ {
//          print("There are at least \(apostleCount) apostles.")
//      }

// an alternative to the above loop
for apostleCount in 0...12 {
    print("There are at least \(apostleCount) apostles.")
}


for number in 1...5 {
    print("\(number) times 4 is \(number * 4)")
} // closed range, as number = 1, then 2, ..., then 5

for number in 0 ..< 5 {
    print("\(number) times 4 is \(number * 4)")
} // half-closed range, which goes from 0 to 4 but does not include 5

for name in ["Anna", "Alex", "Miguel", "John"] {
    print("Hello, \(name)")
}

for letter in "some string".characters {
    print(letter)
}


for (animalName, legCount) in numberOfLegs {
    print("\(animalName)s have \(legCount) legs")
}





// -------------------- MODIFYING COLLECTION TYPES ------------------------
// Array Modification ------------------------------
var shoppingList = ["Eggs", "Milk"]
print(shoppingList[0])
shoppingList += ["Flour"]
shoppingList += ["Cheese", "Spinach"]
shoppingList[0] = "Six eggs"
// shoppingList[3...5] = ["Kale", "Apples", "Soy"]

// Dictionary Modification -------------------------
numberOfLegs["spider"] = 273
numberOfLegs["spider"] = 8
// but what if we want to know value of some key that might or might not be in the dictionary?





// ---------------------- OPTIONALS ---------------------------------------
// Optionals are an interesting feature of Swift.  Here is an example:

var applebysIsGood: Bool!
// currently exists in `nil` state, as I've never been to Applebys.
// OK I just went and it was pretty bad, so now I can give it a meaningful value.
applebysIsGood = false

// A note on bang vs. question mark usage ----------------------------------
// The difference between the two optional operators (? and !) is subtle and kind of boring.
// Xcode will let you know (before compiling) if your usage is incorrect.

let possibleLegCount: Int? = numberOfLegs["aardvark"]
// this will return the number of legs of an aardvark if the value exists
// or will return nil if it doesn't.
if possibleLegCount == nil {
    print("Aardvark wasn't found")
} else {
    let legCount = possibleLegCount!
    // "!" is the "unwrap operator"
    // forcing the value out; "if this value exists, do something with it"
    print("An aardvark has \(legCount) legs")
}
// could also say:
if (possibleLegCount != nil) {
    let legCount = possibleLegCount!
    print("An aardvark has \(legCount) legs")
}
// could also say:
if let legCount = possibleLegCount {
    print("An aardvark has \(legCount) legs")
}







// ----------------------- CONTROL STATEMENTS --------------------------------
// If statements --------------------------------------------
let astronauts = 7
if astronauts == 0 {
    print("Nobody's been to space")
} else if astronauts == 1 {
    print("One person has been to space")
} else {
    print("\(astronauts) people have been to space")
}

// we're comparing astronauts in each if, so why not use a switch statement?
// Switch statements -----------------------------------------
switch astronauts {
case 0:
    print("Nobody's been to space")
case 1:
    print("One person has been to space")
case 2,3:
    print("Only a few people have been to space.")
case 4...6:
    print("A good number of people have been to space.")
default:
    print("\(astronauts) people have been to space.")
}

// Notice how we didn't specify `break` anywhere!
// In Swift, switch statements DON'T fall through.

// Also note the colon usage.  This is the only exception that I know to the "of type" rule.


// -------------------------- FUNCTIONS -------------------------------
func sayHello(name: String) {
    print("Hello, \(name)!")
}

sayHello(name: "Miguel")

// can have default values:
func sayGoodbye(name: String = "person I don't know") {
    print("Goodbye, \(name)!")
}

sayGoodbye()
sayGoodbye(name: "Miguel")

// specify return type with "->"
func buildGreeting(name: String = "person I don't know") -> String {
    return "Hello " + name
}

print(buildGreeting())







// ------------------------- TUPLES ------------------------------
// Apparently pronounced "tuh-pls"
let x = (3.399, 3.98, 4.215)    // (Double, Double, Double)
let y = (404, "Not found")      // (Int, String)
let z = (12, "banana", 0.72)    // (Int, String, Double)

// functions can return tuples
func refreshWebPage() -> (code: Int, message: String) {
    // ...try to refresh...
    return (200, "Success")
}

let (statusCode, message) = refreshWebPage()
// called "decomposing the tuple;" statusCode and message are both bound to the respective return tuples (tuhples)
print("Recieved \(statusCode): \(message)")
// but we can set a value to the whole tuple and then select values from that:
let status = refreshWebPage()
print("Recieved \(status.code): \(status.message)")








// -------------------------- CLOSURES ----------------------------
// they look just like functions because functions are just special closures
// notice we could also say "let greetPrinter ()->() { ... }"
let greetPrinter = {
    print("Hello, printer!")
    print("I would like to purchase an ink cartridge for $7,000.")
}

// closures can be parameters
func doNumTimes(count: Int, task: ()->()) {
    for _ in 0 ..< count {
        task()
    }
}

// calling a function that takes a closure as a parameter
doNumTimes(count: 2, task: {
    print("Hello!")
})

// The syntax for that above statement is ugly.
// Swift features a "trailing closure" syntax.
// If the closure is the last argument in the call, use the following syntax:
doNumTimes(count: 2) {
    print("Hello!")
}






// -------------------------- CLASSES -----------------------------
// Swift doesn't have header files, so there's no ... import "Vehicle.h" ...
class Vehicle {
    // "stored" properties
    var numberOfWheels: Int = 0
    var color: String = ""
    var model: String = ""
    var speed: Double = 0.0
    
    // "computed" properties
    var description: String {
        get {
            // a read-only computed property
            return "A \(color) \(model) with \(numberOfWheels) wheels, traveling at \(speed) mph."
        }
        // if you want "description" to be a read/write computed property, you would include a set { ... } statement here.
    }
    
    
    // methods
    
    func changeSpeed(to newSpeed: Double) {
        let tempStr: String
        if (newSpeed >= speed) {
            tempStr = "Accelerating"
        } else {
            tempStr = "Decelerating"
        }
        speed = newSpeed
        print("\(tempStr) to \(speed) mph")
    }
    
    
    // initializers
    init(numWheels: Int, model: String, color: String) {
        self.color = color
        self.model = model
        self.numberOfWheels = numWheels
    }
    
    
}



class Bicycle: Vehicle {
    // a subclass of the Vehicle superclass
    init(model: String, color: String) {
        super.init(numWheels: 2, model: model, color: color)
    }
}

var myBike = Bicycle(model: "Raymond", color: "red")
print(myBike.description)

class Car: Vehicle {
    // a subclass of the Vehicle superclass
    init(model: String, color: String) {
        super.init(numWheels: 4, model: model, color: color)
    }
    
}



class Counter {
    var count = 0
    func incrementBy(amount: Int) {
        count += amount
    }
    func resetToCount(count: Int) {
        self.count = count
    }
}







// ------------------ BEYOND CLASSES ----------------------
// STRUCTURES
struct Point {
    var x, y: Double
}

struct Size {
    var width, height: Double
}

struct Rect {
    var origin: Point
    var size: Size
    // computed properties in structures? You betcha!
    var area: Double {
        return size.width * size.height
    }
    // methods? Sure!
    func isBiggerThanRect(other: Rect) -> Bool {
        return self.area > other.area
    }
}

var point = Point(x: 0.0, y: 0.0)
var size = Size(width: 640.0, height: 480.0)
var rect = Rect(origin: point, size: size)

// Structures and Classes are pretty much the same, except for two big differences:
// 1. Structures cannot inherit from other structures
// 2. How values are passed around. Classes are passed by reference, structures are passed by value.

// Constants and variables
var point1 = Point(x: 0.0, y: 0.0)
point1.x = 5

let point2 = Point(x: 0.0, y: 0.0)
// CAN'T say point2.x = 5, because the entire thing is a constant






// ------------------- ENUMERATIONS ------------------------
enum Planet: Int {
    case Mercury = 1, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Neptune
    // a one-based index, but could've just as easily been 0-based or 10000-based
}

let earthNumber = Planet.Earth.rawValue
print(earthNumber)

enum ControlCharacter: Character {
    case Tab = "\t"
    case Linefeed = "\n"
    case CarriageReturn = "\r"
}

enum CompassPoint {
    case North, South, East, West
}

var directionToHead = CompassPoint.West
directionToHead = .East

enum TrainStatus {
    
    case OnTime, Delayed(Int)
    
    init() {
        self = .OnTime
    }
    
    var description: String {
        switch self {
        case .OnTime:
            return "on time"
        case .Delayed(let minutes):
            var plural = "s"
            if minutes == 1 {
                plural = ""
            }
            return "delayed by \(minutes) minute\(plural)"
            
        }
    }
}

var tStatus = TrainStatus.OnTime
tStatus = .Delayed(42)

print("The train is now \(tStatus.description)")






// -------------------- GENERICS -------------------------
struct Stack<T> {
    var elements = [T]()
    
    mutating func push(_ element: T) {
        elements.append(element)
    }
    mutating func pop() -> T {
        return elements.removeLast()
    }
}

var intStack = Stack<Int>()
intStack.push(50)
print(intStack.pop())















