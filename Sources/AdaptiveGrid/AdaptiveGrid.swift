import SwiftUI

/// A container view that arranges its children in an adaptive grid with equal row heights.
///
/// `AdaptiveGrid` automatically determines the optimal number of columns based on the
/// available width and the content of its children. All rows have equal height, determined
/// by the tallest subview.
///
/// ## Equal Width Mode
///
/// By default, each column width adapts to its content. To make all columns equal width,
/// apply the `.equalWidth()` modifier:
///
/// ```swift
/// AdaptiveGrid {
///     ForEach(items) { item in
///         ItemView(item)
///     }
/// }
/// .equalWidth()
/// ```
///
/// ## Spacing
///
/// Control spacing between columns and rows with the initializer parameters:
///
/// ```swift
/// AdaptiveGrid(horizontalSpacing: 16, verticalSpacing: 12) {
///     // content
/// }
/// ```
public struct AdaptiveGrid<Content: View>: View {
    @Environment(\.equalWidth) private var equalWidth

    let alignment: Alignment
    let horizontalSpacing: CGFloat?
    let verticalSpacing: CGFloat?
    let content: Content

    /// Creates an adaptive grid with the specified alignment and spacing.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the grid and its subviews.
    ///     Defaults to `.center`.
    ///   - horizontalSpacing: The horizontal distance between adjacent columns.
    ///     If `nil`, uses a default spacing of 8 points.
    ///   - verticalSpacing: The vertical distance between adjacent rows.
    ///     If `nil`, uses a default spacing of 8 points.
    ///   - content: A view builder that creates the grid's content.
    public init(
        alignment: Alignment = .center,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content()
    }

    public var body: some View {
        AdaptiveGridLayout(
            alignment: alignment,
            horizontalSpacing: horizontalSpacing,
            verticalSpacing: verticalSpacing,
            equalWidth: equalWidth
        ) {
            content
        }
    }
}
