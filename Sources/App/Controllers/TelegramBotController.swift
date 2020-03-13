//
//  TelegramBotController.swift
//  App
//
//  Created by Tbxark on 2018/12/28.
//

import Vapor
import TelegramBotAPI

typealias HookResponse = TelegramAPI.Either<TelegramModel<TelegramAPI.Message>, String>

class TelegramBotController: RouteCollection {

    private struct MessageHookContainer: Codable {
        let update_id: Int
        let message: TelegramAPI.Message
    }

    let name: String
    let token: String

    init(name: String, token: String) {
        self.name = name
        self.token = token
    }

    func boot(router: Router) throws {
        router.get(name, token, "getUpdate", use: self.getUpdate)
        router.post(name, token, use: self.hook)
    }
    

    /// GET  /:name/:token
    func getUpdate(_ req: Request) throws -> Future<TelegramModel<[TelegramAPI.Update]>> {
        let offset: Int? = try? req.query.get(at: "offset")
        let tgReq = TelegramAPI.getUpdates(offset: offset)
        return try req.sendTelegramRequest(tgReq, token: token)
    }
    

    /// POST /:name/:token
    func hook(_ req: Request) throws -> Future<HookResponse> {
        let data = try req.http.body.data.get(orThrow: HTTPError(identifier: "Telegram request", reason: "data not found"))
        let model = try JSONDecoder().decode(MessageHookContainer.self, from: data)
        let response = try self.handleWebhookMessage(model.message, at: req)
        return response
    }

    func handleWebhookMessage(_ message: TelegramAPI.Message, at worker: Container) throws -> Future<HookResponse> {
        print("\(message.from?.username ?? "UnknowUser") -> \(message.chat.id) -> \(message.text ?? "")")
        return worker.future(HookResponse("Success"))
    }

}

extension TelegramAPI.Either: ResponseEncodable where A: ResponseEncodable, B: ResponseEncodable {
    public func encode(for req: Request) throws -> EventLoopFuture<Response> {
        switch self {
        case .left(let a):
            return try a.encode(for: req)
        case .right(let b):
            return try b.encode(for: req)
        }
    }
}
