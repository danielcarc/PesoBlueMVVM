//
//  ErrorViewController.swift
//  Pesoblu
//
//  Created by OpenAI ChatGPT.
//

import UIKit

final class ErrorViewController: UIViewController {
    private let message: String
    private let retryHandler: (() -> Void)?

    init(message: String, retryHandler: (() -> Void)? = nil) {
        self.message = message
        self.retryHandler = retryHandler
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel()
        label.text = message
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("retry_button", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func didTapRetry() {
        dismiss(animated: true) {
            self.retryHandler?()
        }
    }
}
