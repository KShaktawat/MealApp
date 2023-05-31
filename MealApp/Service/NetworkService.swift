//
//  NetworkService.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import Foundation
import Combine

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL?, decodeType: T.Type) -> Future<T, Error>
}

final class NetworkService: NetworkServiceProtocol {

    private var cancellables = Set<AnyCancellable>()
    /**
      Perform an HTTPS request and decode the response.

      - Parameters:
        - url: The URL for the HTTPS request.
        - decodeType: The type to which the response should be decoded.

      - Returns: A 'Future' object representing the asynchronous result of the request, with a success type of 'T' and an error type of 'Error'.
     */
    func request<T: Decodable>(url: URL?, decodeType: T.Type) -> Future<T, Error> {
        return Future<T, Error> { [weak self] promise in
            guard let self = self,
                  let url = url else {
                return promise(.failure(NetworkError.invalidURL))
            }
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForResource = 60.0 // 60 seconds
            let session = URLSession(configuration: configuration)
            session.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.invalidResponse }
                    return data
                }
                .decode(type: decodeType.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                } receiveValue: { promise(.success($0)) }
                .store(in: &self.cancellables)
        }
    }

}
