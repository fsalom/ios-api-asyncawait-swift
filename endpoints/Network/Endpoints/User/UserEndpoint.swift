import Foundation

enum UserEndpoint {
    case me
    case error([String: Any])
    case edit(String, [String: Any])
    
    var endpoint: Endpoint {
        get {
            switch self {
            case .me:
                return Endpoint(path: "/users/me/", httpMethod: .get)
            case .error(let parameters):
                return Endpoint(path: "/users/error/", httpMethod: .post, parameters: parameters)
            case .edit(let user, let parameters):
                return Endpoint(path: "/users/\(user)/", httpMethod: .patch, parameters: parameters)
            }
        }
    }
}
