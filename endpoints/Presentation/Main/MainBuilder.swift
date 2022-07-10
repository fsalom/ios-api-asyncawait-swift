import UIKit

final class MainBuilder {
    func build() -> MainViewController {
        let viewController = UIViewController.instantiate(viewController: MainViewController.self)
        let router = MainRouter(viewController: viewController)
        let viewModel = MainViewModel(router: router)
        viewController.viewModel = viewModel
        return viewController
    }
}
