import Cocoa

var str = "Hello, playground"

//: # Clousures

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
