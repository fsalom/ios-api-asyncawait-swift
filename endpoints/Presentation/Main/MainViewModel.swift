import UIKit

final class MainViewModel {

    // MARK: - Properties
    private let router: MainRouter

    // MARK: - Init
    required init(router: MainRouter) {
        self.router = router
    }
}

// MARK: - Life cycle
extension MainViewModel {
    func viewReady() {
        // Called when view is loaded and ready
    }

    func viewDidAppear() {

    }
}
