import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { _ in
        return "It works!"
    }

    let echo = EchoBotController(name: "VaporEchoBot", token: "1095723301:AAGuEgDe6YqvmLBbINKn208MZtNKZtG78jc")
    try router.register(collection: echo)

}
