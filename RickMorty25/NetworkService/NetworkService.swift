//
//  NetworkService.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import Foundation

struct NetworkResponse {
    let json: Any
    let statusCode: Int
}

class NetworkService {

    let scheme = "https"
    let host = "rickandmortyapi.com"

    public static let shared = NetworkService()
    private init() {}

    private func getHeader(accessToken: String? = nil,
                           isMultipart: Bool = false,
                           boundary: String? = nil) -> [String: String] {
        var header: [String: String] = ["Content-Type": isMultipart ? "multipart/form-data; boundary=\(boundary ?? "")" : "application/json"]
        if let token = accessToken {
            header["token"] = "\(token)"
        }
        return header
    }

    private func formUrl(endpoint: NetworkApiMethods,
                         pathSuffics: String? = nil,
                         queryParams: [String: String]? = nil) -> String {

        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        var path = endpoint.path
        if let suffics = pathSuffics {
            path += "/\(suffics)"
        }
        components.path = path

        if let queryParams = queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        return components.url?.absoluteString ?? ""
    }

    private func sendRequest(method: String,
                             url: String,
                             headers: [String: String]? = nil,
                             body: Any? = nil,
                             isImageUpload: Bool = false,
                             completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {

        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers ?? getHeader()

        if method != "GET" {
            request.httpBody = body as? Data
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(NetworkError.invalidTask))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.decodingError))
                return
            }
            let contentType = httpResponse.allHeaderFields["Content-Type"] as? String ?? ""
            if contentType.contains("application/json"), let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let statusCode = httpResponse.statusCode
                    if (200...299).contains(httpResponse.statusCode) {
                        let response = NetworkResponse(json: json, statusCode: statusCode)
                        completion(.success(response))
                    } else {
                        completion(.failure(NetworkError.unknownError))
                    }
                } catch {
                    let statusCode = httpResponse.statusCode
                    completion(.failure(NetworkError.unknownError))
                }
            } else {
                let statusCode = httpResponse.statusCode
                completion(.failure(NetworkError.unknownError))
            }
        }
        task.resume()
    }

    private func GET(url: String,
                     headers: [String: String]? = nil,
                     completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        sendRequest(method: "GET",
                    url: url,
                    headers: headers,
                    body: nil,
                    isImageUpload: false,
                    completion: completion)
    }

    func getCharacters(queryParams: [String: String]? = nil,
                       completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .character, queryParams: queryParams)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }

    func getLocation(id: Int,
                     queryParams: [String: String]? = nil,
                     completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .location, pathSuffics: String(id), queryParams: queryParams)
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }

    func getEpisode(id: Int,
                     queryParams: [String: String]? = nil,
                     completion: @escaping (Result<NetworkResponse, NetworkError>) -> Void) {
        let url = formUrl(endpoint: .episode, pathSuffics: String(id), queryParams: queryParams)
        print(url)
        let headers = getHeader()
        GET(url: url, headers: headers, completion: completion)
    }
}
