import UIKit

func topMostController() -> UIViewController? {
    guard let window = keyWindow, let rootViewController = window.rootViewController else {
        return nil
    }

    var topController = rootViewController

    while let newTopController = topController.presentedViewController {
        topController = newTopController
    }

    return topController
}

let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
let safeAreaHeight = keyWindow?.safeAreaLayoutGuide.layoutFrame.height ?? 0
let safeAreaWidth = keyWindow?.safeAreaLayoutGuide.layoutFrame.width ?? 0
let screenHeight = keyWindow?.frame.height ?? 0
let screenWidth = keyWindow?.frame.width ?? 0

func changeRoot(to viewController: UIViewController) {
    UIView.transition(with: keyWindow!, duration: 0.3, options: .transitionCrossDissolve, animations: {
        DispatchQueue.main.async {
            keyWindow?.rootViewController = viewController
        }
    })
}
