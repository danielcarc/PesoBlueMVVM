import UIKit

protocol AlertPresentable {
    func show(message: String, on viewController: UIViewController)
}

struct AlertPresenter: AlertPresentable {
    func show(message: String, on viewController: UIViewController) {
        let alert = UIAlertController(title: NSLocalizedString("error_title", comment: ""),
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_action", comment: ""),
                                      style: .default))
        viewController.present(alert, animated: true)
    }
}

