import Foundation

class Container {
    static let shared = Container()
}

extension Container {
    func loginBuilder() -> LoginBuilder {
        return LoginBuilder()
    }
}
