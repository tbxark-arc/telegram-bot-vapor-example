import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    // Basic "It works" example
    router.get { _ in
        return "It works!"
    }

    let echo = EchoBotController(name: "VaporEchoBot", token: "767536579:AAEzJntct6DD_p3eVMVA2Y9Biw4VtY8p0RU")
    try router.register(collection: echo)

}
