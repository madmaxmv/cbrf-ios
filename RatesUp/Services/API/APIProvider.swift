//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Combine
import Foundation

protocol APIProvider {

    func publisher<Response, Decoder: TopLevelDecoder>(
        for request: APIRequest<Response>,
        using decoder: Decoder
    ) -> AnyPublisher<Response, APIError> where
        Response: Decodable, Decoder.Input == Data
}

final class APIProviderImpl: APIProvider {
    private let session: URLSession
    private let configuration: APIConfiguration

    init(session: URLSession, configuration: APIConfiguration) {
        self.session = session
        self.configuration = configuration
    }

    func publisher<Response, Decoder: TopLevelDecoder>(
        for request: APIRequest<Response>,
        using decoder: Decoder
    ) -> AnyPublisher<Response, APIError> where
        Response: Decodable, Decoder.Input == Data
    {
        session.dataTaskPublisher(for: urlRequest(request))
            .mapError(APIError.networking)
            .map(\.data)
            .decode(type: Response.self, decoder: decoder)
            .mapError(APIError.decoding)
            .eraseToAnyPublisher()
    }

    private func urlRequest<R>(_ apiRequest: APIRequest<R>) -> URLRequest {
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
