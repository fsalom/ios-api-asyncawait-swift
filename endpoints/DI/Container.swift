import Foundation

class Container {
    static let shared = Container()
}

extension Container {
    func mainBuilder() -> MainBuilder {
        return mainBuilder()
    }
}
