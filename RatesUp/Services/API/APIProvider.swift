//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

protocol APIProvider {

    func publisher<Request: APIRequest, Decoder: TopLevelDecoder>(
        for request: Request,
        using decoder: Decoder
    ) -> AnyPublisher<Request.Response, APIError> where
        Request.Response: Decodable, Decoder.Input == Data
}

final class APIProviderImpl: APIProvider {
    private let session: URLSession
    private let configuration: APIConfiguration

    init(session: URLSession, configuration: APIConfiguration) {
        self.session = session
        self.configuration = configuration
    }

    func publisher<Request: APIRequest, Decoder: TopLevelDecoder>(
        for request: Request,
        using decoder: Decoder
    ) -> AnyPublisher<Request.Response, APIError> where
        Request.Response: Decodable, Decoder.Input == Data
    {
        session.dataTaskPublisher(for: urlRequest(request))
            .mapError(APIError.networking)
            .map(\.data)
            .decode(type: Request.Response.self, decoder: decoder)
            .mapError(APIError.decoding)
            .eraseToAnyPublisher()
    }

    private func urlRequest<Request: APIRequest>(_ apiRequest: Request) -> URLRequest {
        let url = configuration.baseURL()
            .appendingPathComponent(apiRequest.endpoint)
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
