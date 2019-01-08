//
//  TelegramBotService.swift
//  App
//
//  Created by Tbxark on 2018/12/28.
//

import Vapor
import TelegramBotAPI

final class TelegramBotService: Service, ServiceType {

    public var container: Container

    private init(container: Container) {
        self.container = container
    }

    static func makeService(for worker: Container) throws -> TelegramBotService {
        return TelegramBotService(container: worker)
    }

    func sendRequest<T: Codable>(_ request: TelegramAPI.Request, token: String) throws -> Future<TelegramModel<T>> {
        let client = try container.client()
        let httpReq = try HTTPRequest.build(from: request, token: token)
        return client.send(Request(http: httpReq, using: container))
            .map({ response -> TelegramModel<T> in
                let data = try response.http.body.data.get(orThrow: HTTPError(identifier: "Telegram request", reason: "data not found"))
                var model = try JSONDecoder().decode(TelegramModel<T>.self, from: data)
                model.httpResponseStatus = response.http.status
                return model
            })
    }

}

extension Container {
    func sendTelegramRequest<T: Codable>(_ request: TelegramAPI.Request, token: String) throws -> Future<TelegramModel<T>> {
        let service = try self.make(TelegramBotService.self)
        return try service.sendRequest(request, token: token)
    }
}
