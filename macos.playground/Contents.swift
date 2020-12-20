import Cocoa

var str = "Hello, playground"

print("-------------------------------------------------- Tuples")

let http404Error = (404, "Not Found")
print(type(of: http404Error))
print("http404Error is \(http404Error):")
print(http404Error.0)
print(http404Error.1)

let http200Status = (statusCode: 200, description: "OK")
print(type(of: http200Status))
print("http200Status is \(http200Status)")
print(http200Status.statusCode)
print(http200Status.description)

print("-------------------------------------------------- Optionals")

print("type(of: Int(\"123\"))", type(of: Int("123")))  // Int?
if let i = Int("123") {
    print(type(of: i))  // Int
}
if var i = Int("123") {
    i += 1000
    print(type(of: i))
}
// print(type(of: i))  // Cannot find 'i' in scope

let implicitlyUnwrappedOptionalString : String! = "foo"
print("type(of: implicitlyUnwrappedOptionalString)",
      type(of: implicitlyUnwrappedOptionalString),
      "<= let implicitlyUnwrappedOptionalString : String! = \"foo\"")
print("implicitlyUnwrappedOptionalString!", implicitlyUnwrappedOptionalString!)
let unwrappedString: String = implicitlyUnwrappedOptionalString
print("unwrappedString", unwrappedString)
print("type(of: unwrappedString)", type(of: unwrappedString))

print("-------------------------------------------------- Error Handling")

func canThrowAnError() throws {
}

// canThrowAnError()  // doesn't compile - Call can throw but is not marked by 'try'

do {
    try canThrowAnError()
    // canThrowAnError()  // doesn't compile - Call can throw but is not marked by 'try'
} catch {
    // error handling
}

print("-------------------------------------------------- Strings and Characters")

let ch: Character = "a"
let s: String = "a"

print(s == String(ch))

print("-------------------------------------------------- Clousures")

let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

//: ## flavors of closures

//: ### three-liner
var reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

//: ### one-liner
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 })

//: ### shorter one-liner (inferring type from context)
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 })

//: ### shorter one-liner (inferring type from context; implicit return from single-expression closure)
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

//: ### shorter one-liner (shorthand argument names)
reversedNames = names.sorted(by: { $0 > $1 })

//: ### shorter one-liner (trailing closure)
reversedNames = names.sorted() { $0 > $1 }

//: ### shorter one-liner (trailing closure; no parentheses needed)
reversedNames = names.sorted { $0 > $1 }

//: ### shortest (passing in the greater-than operator)
reversedNames = names.sorted(by: >)

//: ## escaping closures

//: A closure is said to escape a function when the closure is passed as an argument to the function, but is called after the function returns.
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    // If you didn’t mark the parameter of this function with @escaping, you would get a compile-time error.
    completionHandlers.append(completionHandler)
}

//: Marking a closure with @escaping means you have to refer to self explicitly within the closure.

func someFunctionWithNonescapingClosure(closure: () -> Void) {
    closure()
}

class SomeClass {
    var x = 10
    func doSomething() {
        someFunctionWithEscapingClosure { self.x = 100 }
        someFunctionWithNonescapingClosure { x = 200 }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)
// Prints "200"

completionHandlers.first?()
print(instance.x)
// Prints "100"

//: ## autoclosures

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

print(customersInLine.count)
// Prints "5"

let customerProvider = { customersInLine.remove(at: 0) }
print(customersInLine.count)
// Prints "5"

print("Now serving \(customerProvider())!")
// Prints "Now serving Chris!"
print(customersInLine.count)
// Prints "4"

// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) })
// Prints "Now serving Alex!"

// customersInLine is ["Ewa", "Barry", "Daniella"]
func serve2(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve2(customer: customersInLine.remove(at: 0))
// Prints "Now serving Ewa!"

print("-------------------------------------------------- Enumerations")

//: ## Associated Values

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

func printBarcode(_ barcode: Barcode) {
    switch barcode {
    case let .upc(numberSystem, manufacturer, product, check):
        print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
    case let .qrCode(productCode):
        print("QR code: \(productCode)")
    }
}

var productBarcode = Barcode.upc(8, 85909, 51226, 3)

printBarcode(productBarcode)

switch productBarcode {
case .upc(let numberSystem, let manufacturer, var product, let check):
    product += 1  // this won't change productBarcode
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check)")
case let .qrCode(productCode):
    print("QR code: \(productCode)")
}

printBarcode(productBarcode)

//: ## Raw Values

enum ASCIIControlCharacter : Character {
    case tab = "\t"
    case lf = "\n"
    case cr = "\r"
}

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, nepture
}

print(Planet.earth)  // prints earth
print(Planet.earth.rawValue)  // prints 3

enum SpecialStr: String {
    case foo = "a", bar, baz
}

print(SpecialStr.foo)  // prints foo
print(SpecialStr.foo.rawValue)  // print a
print(SpecialStr.bar)  // print bar
print(SpecialStr.bar.rawValue)  // print bar

let possiblePlanet7 = Planet(rawValue: 7)
print(possiblePlanet7 ?? "unknown")  // prints uranus

let possiblePlanet70 = Planet(rawValue: 70)
print(possiblePlanet70 ?? "unknown")  // prints unknown

let possibleSpecialStrBaz = SpecialStr(rawValue: "baz")
print(possibleSpecialStrBaz ?? "blah")  // prints baz

let possibleSpecialStrZzz = SpecialStr(rawValue: "zzz")
print(possibleSpecialStrZzz ?? "blah")  // prints blah
