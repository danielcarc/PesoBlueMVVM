import UIKit

class PlacesListView: UIView  {

    let filterCView: FilterCollectionView
    let placesListCView: PlacesListCollectionView

    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.bounces = true
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let collectionViewHeightConstraint: NSLayoutConstraint

    init(filterCView: FilterCollectionView, placesListCView: PlacesListCollectionView) {
        self.filterCView = filterCView
        self.placesListCView = placesListCView
        self.collectionViewHeightConstraint = placesListCView.heightAnchor.constraint(equalToConstant: 200)
        super.init(frame: .zero)
        setup()
    }

    /// This view is intended to be instantiated programmatically.
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    private func setup() {
        addSubview(mainScrollView)
        mainScrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(filterCView)
        stackView.addArrangedSubview(placesListCView)

        filterCView.translatesAutoresizingMaskIntoConstraints = false
        placesListCView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainScrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            mainScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.trailingAnchor, constant: -10),
            contentView.widthAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.widthAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: mainScrollView.contentLayoutGuide.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            filterCView.heightAnchor.constraint(equalToConstant: 142),
            collectionViewHeightConstraint
        ])

        let heightConstraint = contentView.heightAnchor.constraint(equalTo: mainScrollView.frameLayoutGuide.heightAnchor)
        heightConstraint.priority = .defaultLow
        heightConstraint.isActive = true
    }
}

