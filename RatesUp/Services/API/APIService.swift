//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

protocol APIService {

    func publisher<Request: APIRequest, Decoder: TopLevelDecoder>(
        for request: Request,
        using decoder: Decoder
    ) -> AnyPublisher<Request.Response, APIError> where
        Request.Response: Decodable,
        Decoder.Input == Data
}

final class APIServiceImpl {

    private let settings: APISettings
    private let urlSession: URLSession

    init(
        settings: APISettings,
        urlSession: URLSession = .shared
    ) {
        self.settings = settings
        self.urlSession = urlSession
    }
}

// MARK: - APIService
extension APIServiceImpl: APIService {

    func publisher<Request: APIRequest, Decoder: TopLevelDecoder>(
        for request: Request,
        using decoder: Decoder
    ) -> AnyPublisher<Request.Response, APIError> where
        Request.Response: Decodable,
        Decoder.Input == Data
    {
        let urlRequest = makeURLRequest(for: request)

        return urlSession
            .dataTaskPublisher(for: urlRequest)
            .mapError(APIError.networking)
            .map(\.data)
            .decode(
                type: Request.Response.self,
                decoder: decoder
            )
            .mapError(APIError.decoding)
            .eraseToAnyPublisher()
    }

    private func makeURLRequest<Request: APIRequest>(for apiRequest: Request) -> URLRequest {
        let url = URL(string: settings.baseURL() + apiRequest.endpoint)!
        var request = URLRequest(url: url)

        switch apiRequest.method {
        case .put(let data), .post(let data):
            request.httpBody = data
        case .get(let queryItems):
            var components = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false
            )
            components?.queryItems = queryItems
            guard let url = components?.url else {
                preconditionFailure("Couldn't create url")
            }
            request = URLRequest(url: url)
        default:
            break
        }

        request.httpMethod = apiRequest.method.name
        return request
    }
}
