//
//  Base.swift
//  App
//
//  Created by Tbxark on 2018/12/28.
//

import Vapor
import TelegramBotAPI

// MARK: - Optional
extension Optional {
    func get(orThrow error: Error) throws -> Wrapped {
        switch self {
        case .some(let v):
            return v
        default:
            throw error
        }
    }
}

// MARK: - ResponseContainer
struct ResponseContainer<T: Codable>: Codable {
    let error: Bool
    let code: Int
    let reason: String?
    let data: T?
}

// MARK: - TelegramModel
struct TelegramModel<T: Codable>: Codable, ResponseEncodable {
    var httpResponseStatus = HTTPResponseStatus.ok
    let ok: Bool
    let errorCode: Int?
    let description: String?
    let result: T?

    func encode(for req: Request) throws -> Future<Response> {
        let data = try result.get(orThrow: HTTPError(identifier: "JSONDecoder", reason: "\(errorCode ?? 0): \(description ?? "Unknow Error")"))
        let value = try JSONEncoder().encode(ResponseContainer<T>(error: ok, code: errorCode ?? 0, reason: description, data: data))
        let httpRespone = HTTPResponse(status: httpResponseStatus,
                                       headers: HTTPHeaders([("Content-Type", "application/json; charset=utf-8")]),
                                       body: value)
        let response = Response(http: httpRespone, using: req)
        return try Response.decode(from: response, for: req)
    }

    private enum CodingKeys: String, CodingKey {
        case ok
        case errorCode = "error_code"
        case description = "description"
        case result = "result"
    }
}

// MARK: - HTTPRequest
extension HTTPRequest {
    static func build(from request: TelegramAPI.Request, token: String) throws -> HTTPRequest {

        let url = try URL(string: "https://api.telegram.org/bot\(token)/\(request.method)").get(orThrow: URLError(.badURL))
        let data = try TelegramAPI.AnyEncodable.encode(request.body)
        let httpRequest = HTTPRequest(method: HTTPMethod.POST,
                                      url: url,
                                      headers: HTTPHeaders([("Content-Type", "application/json; charset=utf-8")]),
                                      body: data)
        return httpRequest
    }
}

extension TelegramAPI.ChatId: ExpressibleByIntegerLiteral, ExpressibleByStringLiteral {
    public typealias IntegerLiteralType = Int
    public typealias StringLiteralType = String

    public init(stringLiteral value: TelegramAPI.ChatId.StringLiteralType) {
        self = TelegramAPI.ChatId(value)
    }

    public init(integerLiteral value: TelegramAPI.ChatId.IntegerLiteralType) {
        self = TelegramAPI.ChatId(value)
    }
}
