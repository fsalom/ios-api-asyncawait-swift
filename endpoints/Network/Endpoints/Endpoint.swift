import Foundation
import UIKit

struct Endpoint {
    enum HTTPMethod {
        case get
        case post
        case patch
        case delete

        var rawValue: String {
            switch self {
            case .get: return "GET"
            case .post: return "POST"
            case .patch: return "PATCH"
            case .delete: return "DELETE"
            }
        }
    }

    enum Encoding {
        case json
        case multipart

        var rawValue: String {
            switch self {
            case .json: return "application/json; charset=utf-8"
            case .multipart: return "multipart/form-data; boundary=\(UUID().uuidString)"
            }
        }
    }
    var headers: [String: String]
    var path: String
    var httpMethod: HTTPMethod
    var encoding: Encoding
    var parameters: [String: Any]
    var images: [String: UIImage]
    var videos: [String: String]
    var request: URLRequest {
        get {
            let url = getURL(path: self.path)
            var request = URLRequest(url: url)
            request.httpMethod = self.httpMethod.rawValue
            for header in self.headers {
                request.setValue(header.value, forHTTPHeaderField: header.key)
            }
            switch self.httpMethod{
            case .get:
                if !parameters.isEmpty { request = setURLEncoding(for: url) }
            case .post, .patch:
                request.setValue(encoding.rawValue, forHTTPHeaderField: "Content-Type")
                request.setValue("y5cUsYg5A4CJsCUFPmUy4LwBUn0nGBOj", forHTTPHeaderField: "X-API-ACCESS-TOKEN")
                switch getEncoding() {
                case .json:
                    request = setJSONEncoding(for: request)
                case .multipart:
                    request = setMultiPartEncoding(for: request)
                }
            default:
                break
            }
            return request
        }
    }
    
    init(path: String,
         httpMethod: HTTPMethod,
         parameters: [String: Any] = [:],
         encoding: Encoding = .json,
         images: [String: UIImage] = [:],
         videos: [String: String] = [:],
         headers: [String: String] = [:]) {
        self.path = path
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.videos = videos
        self.images = images
        self.encoding = encoding
        self.headers = headers
    }
    
    // MARK: - get URL with BASE_URL
    func getURL(path: String) -> URL {
        guard let url = URL(string: Config.baseURL
        )?.appendingPathComponent(path) else {
            Log.this(path, type: .error)
            fatalError()
        }
        return url
    }
    
    // MARK: - set Encoding depending on all variables
    func getEncoding() -> Encoding {
        switch httpMethod {
        case .post, .patch:
            var newEncoding = encoding == .none ? .json : encoding
            if !videos.isEmpty || !images.isEmpty {
                newEncoding = .multipart
            }
            return newEncoding
        default:
            return .json
        }
    }
    
    // MARK: - set JSON encoding parameters
    func setJSONEncoding(for request: URLRequest) -> URLRequest {
        var request = request
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            fatalError()
        }
        request.httpBody = httpBody
        return request
    }
    
    // MARK: - set URL encoding parameters
    func setURLEncoding(for url: URL) -> URLRequest {
        var components = URLComponents(string: url.absoluteString)!
        components.queryItems = self.parameters.map { (key, value) in
            URLQueryItem(name: key, value: value as? String)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return URLRequest(url: components.url!)
    }
    
    // MARK: - set JSON encoding parameters
    func setMultiPartEncoding(for request: URLRequest) -> URLRequest {
        var request = request
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            fatalError()
        }
        request.httpBody = httpBody
        return request
    }
}
