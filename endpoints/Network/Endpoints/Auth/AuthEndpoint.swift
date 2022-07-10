import Foundation

enum AuthEndpoint {
    case login([String: Any])
    case refreshToken([String: Any])

    var endpoint: Endpoint {
        get {
            switch self {
            case .login(let parameters):
                return Endpoint(path: "/auth/token/", httpMethod: .post, parameters: parameters, encoding: .json)
            case .refreshToken(let parameters):
                return Endpoint(path: "/google/refresh_token", httpMethod: .post, parameters: parameters, encoding: .json)
            }
        }
    }
}
