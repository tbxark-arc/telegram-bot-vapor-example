//
//  EchoBotController.swift
//  App
//
//  Created by Tbxark on 2018/12/28.
//

import Vapor
import TelegramBotAPI

class EchoBotController: TelegramBotController {

    override func boot(router: Router) throws {
        try super.boot(router: router)
        router.get(name, token, String.parameter, String.parameter, use: self.quickSend)
    }

    /// GET  /:name/:token/:id/:message
    func quickSend(_ req: Request) throws -> Future<TelegramModel<TelegramAPI.Message>> {
        let chatId = try req.parameters.next(String.self)
        let text = try req.parameters.next(String.self)
        let tgReq = TelegramAPI.sendMessage(chatId: TelegramAPI.ChatId(chatId), text: text.removingPercentEncoding ?? text)
        return try req.sendTelegramRequest(tgReq, token: token)
    }

    override func handleWebhookMessage(_ message: TelegramAPI.Message, at worker: Container) throws -> EventLoopFuture<HookResponse> {
        print("\(message.from?.username ?? "UnknowUser") -> \(message.chat.id) -> \(message.text ?? "")")
        let text = "Re: \(message.text ?? "")"
        let tgReq = TelegramAPI.sendMessage(chatId: TelegramAPI.ChatId(message.chat.id), text: text)
        let msg: Future<TelegramModel<TelegramAPI.Message>> = try worker.sendTelegramRequest(tgReq, token: token)
        return msg.map({ HookResponse($0)})
    }

}
