import UIKit

final class MainRouter {
    // MARK: - Properties
    private weak var viewController: MainViewController?

    // MARK: - Init
  required init(viewController: MainViewController?) {
        self.viewController = viewController
    }
}

