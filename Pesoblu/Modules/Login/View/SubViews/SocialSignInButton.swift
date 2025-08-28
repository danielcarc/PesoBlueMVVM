import UIKit

final class SocialSignInButton: UIButton {

    init(title: String, image: UIImage?, accessibilityIdentifier: String) {
        super.init(frame: .zero)
        setup(title: title, image: image)
        self.accessibilityLabel = title
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    private func setup(title: String, image: UIImage?) {
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 0.91, green: 0.94, blue: 0.96, alpha: 1.0)
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: LayoutConstants.buttonHeight)
        ])

        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = title
            config.image = image
            config.imagePlacement = .leading
            config.imagePadding = 10
            config.baseForegroundColor = .black
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            self.configuration = config
        } else {
            self.setTitle(title, for: .normal)
            self.setTitleColor(.black, for: .normal)
            self.setImage(image, for: .normal)
            self.titleLabel?.font = .boldSystemFont(ofSize: 16)
            self.imageView?.contentMode = .scaleAspectFit
            self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        }
    }
}
