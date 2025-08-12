import UIKit

/// Centralized layout metrics for consistent spacing and sizing across the app.
enum LayoutConstants {
    // MARK: - Padding and Spacing
    /// Default horizontal padding for leading and trailing anchors.
    static let edgePadding: CGFloat = 10
    /// Small padding used for top/bottom spacing and compact insets.
    static let smallPadding: CGFloat = 8
    /// Large spacing used to separate sections vertically.
    static let largeSpacing: CGFloat = 16
    /// Spacing between items in collection views.
    static let itemSpacing: CGFloat = 10
    /// Tiny spacing for closely related elements such as stacked labels.
    static let tinySpacing: CGFloat = 4
    /// Extra small padding used inside cells for tight layouts.
    static let extraSmallPadding: CGFloat = 5

    // MARK: - Sizes
    /// Standard height for currency containers in the quick converter.
    static let converterContainerHeight: CGFloat = 50
    /// Width for value labels in the quick converter.
    static let valueLabelWidth: CGFloat = 80
    /// Height for images displayed in city cells.
    static let cityImageHeight: CGFloat = 100
    /// Height for city items in the collection view.
    static let cityItemHeight: CGFloat = 130
    /// Width for items in the discover collection view and images inside discover cells.
    static let discoverItemWidth: CGFloat = 160
    /// Height for items in the discover collection view.
    static let discoverItemHeight: CGFloat = 120
    /// Height for images inside discover cells.
    static let discoverImageHeight: CGFloat = 90

    // MARK: - Corner Radius
    /// Corner radius applied to rounded container views.
    static let containerCornerRadius: CGFloat = 8
    /// Corner radius for city collection view cells.
    static let cityCellCornerRadius: CGFloat = 10
    /// Corner radius for discover cells and their images.
    static let discoverCellCornerRadius: CGFloat = 6

    // MARK: - Fonts
    /// Title font size for the quick converter.
    static let converterTitleFontSize: CGFloat = 22
    /// Font size for currency code labels.
    static let currencyCodeFontSize: CGFloat = 16
    /// Font size for currency description labels.
    static let currencyDescriptionFontSize: CGFloat = 14
    /// Font size for currency value labels.
    static let currencyValueFontSize: CGFloat = 16
    /// Font size for section headers such as "Discover Buenos Aires".
    static let sectionHeaderFontSize: CGFloat = 18
    /// Font size for titles in city cells.
    static let cityCellTitleFontSize: CGFloat = 16
    /// Font size for titles in discover cells.
    static let discoverCellTitleFontSize: CGFloat = 18

    // MARK: - Layout Calculations
    /// Total horizontal padding considered when computing available width for city collection view items.
    static let totalHorizontalPadding: CGFloat = 40
}

