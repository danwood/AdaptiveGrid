import SwiftUI

struct AdaptiveGridLayout: Layout {
    let alignment: Alignment
    let horizontalSpacing: CGFloat?
    let verticalSpacing: CGFloat?
    let equalWidth: Bool

    struct LayoutCache {
        let equalWidth: Bool
        let columnCount: Int
        let columnWidths: [CGFloat]
        let rowHeight: CGFloat
        let totalSize: CGSize
    }

    func makeCache(subviews: Subviews) -> LayoutCache {
        /*
         Create an empty cache. The actual computation happens in sizeThatFits
         because we need the proposal to determine the layout.
         */
        LayoutCache(
            equalWidth: false,
            columnCount: 0,
            columnWidths: [],
            rowHeight: 0,
            totalSize: .zero
        )
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout LayoutCache
    ) -> CGSize {
        guard !subviews.isEmpty else {
            return .zero
        }

        let proposalWidth = proposal.width ?? 0
        let hSpacing = horizontalSpacing ?? 8
        let vSpacing = verticalSpacing ?? 8

        // Measure all subviews with unspecified proposal to get natural sizes
        let subviewSizes = subviews.map { subview in
            subview.sizeThatFits(.unspecified)
        }

        // Determine row height: max height across all subviews
        let rowHeight = subviewSizes.map(\.height).max() ?? 0

        let columnWidths: [CGFloat]
        let columnCount: Int

        if equalWidth {
            // Equal Width Mode
            let maxWidth = subviewSizes.map(\.width).max() ?? 0

            // Calculate how many columns fit
            if maxWidth > 0 {
                columnCount = max(1, Int((proposalWidth + hSpacing) / (maxWidth + hSpacing)))
            } else {
                columnCount = 1
            }

            // Calculate stretched column width
            let totalSpacing = hSpacing * CGFloat(columnCount - 1)
            let availableForColumns = proposalWidth - totalSpacing
            let stretchedWidth = availableForColumns / CGFloat(columnCount)

            columnWidths = Array(repeating: stretchedWidth, count: columnCount)

        } else {
            // Adaptive Width Mode - iterate to find optimal column count
            var bestColumnCount = 1
            var bestColumnWidths: [CGFloat] = []

            for tryColumns in 1...subviews.count {
                var trialColumnWidths = Array(repeating: CGFloat(0), count: tryColumns)

                // Calculate max width for each column
                for (index, size) in subviewSizes.enumerated() {
                    let columnIndex = index % tryColumns
                    trialColumnWidths[columnIndex] = max(trialColumnWidths[columnIndex], size.width)
                }

                // Check if this configuration fits
                let totalSpacing = hSpacing * CGFloat(tryColumns - 1)
                let totalWidth = trialColumnWidths.reduce(0, +) + totalSpacing

                if totalWidth <= proposalWidth {
                    bestColumnCount = tryColumns
                    bestColumnWidths = trialColumnWidths
                } else {
                    break
                }
            }

            columnCount = bestColumnCount

            // Apply proportional stretching
            let totalNaturalWidth = bestColumnWidths.reduce(0, +)
            let totalSpacing = hSpacing * CGFloat(columnCount - 1)
            let extraSpace = proposalWidth - totalNaturalWidth - totalSpacing

            if extraSpace > 0 && totalNaturalWidth > 0 {
                columnWidths = bestColumnWidths.map { width in
                    let proportion = width / totalNaturalWidth
                    return extraSpace * proportion + width
                }
            } else {
                columnWidths = bestColumnWidths
            }
        }

        // Calculate total grid size
        let rowCount = (subviews.count + columnCount - 1) / columnCount
        let totalWidth = columnWidths.reduce(0, +) + hSpacing * CGFloat(columnCount - 1)
        let totalHeight = rowHeight * CGFloat(rowCount) + vSpacing * CGFloat(rowCount - 1)
        let totalSize = CGSize(width: totalWidth, height: totalHeight)

        // Update cache
        cache = LayoutCache(
            equalWidth: equalWidth,
            columnCount: columnCount,
            columnWidths: columnWidths,
            rowHeight: rowHeight,
            totalSize: totalSize
        )

        return totalSize
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout LayoutCache
    ) {
        guard !subviews.isEmpty else { return }

        // Guardrail: Check if cache is valid
        guard !cache.columnWidths.isEmpty else { return }
        guard cache.columnCount > 0 else { return }

        let hSpacing = horizontalSpacing ?? 8
        let vSpacing = verticalSpacing ?? 8

        // Calculate starting position based on alignment
        var gridOrigin = CGPoint(x: bounds.minX, y: bounds.minY)

        switch alignment.horizontal {
        case .leading:
            gridOrigin.x = bounds.minX
        case .trailing:
            gridOrigin.x = bounds.maxX - cache.totalSize.width
        default: // center
            gridOrigin.x = bounds.minX + (bounds.width - cache.totalSize.width) / 2
        }

        switch alignment.vertical {
        case .top:
            gridOrigin.y = bounds.minY
        case .bottom:
            gridOrigin.y = bounds.maxY - cache.totalSize.height
        default: // center
            gridOrigin.y = bounds.minY + (bounds.height - cache.totalSize.height) / 2
        }

        // Place each subview
        for (index, subview) in subviews.enumerated() {
            let columnIndex = index % cache.columnCount
            let rowIndex = index / cache.columnCount

            // Guardrail: Verify columnIndex is valid
            guard columnIndex < cache.columnWidths.count else { continue }

            // Calculate column x position
            let columnX = gridOrigin.x + cache.columnWidths.prefix(columnIndex).reduce(0, +)
                + hSpacing * CGFloat(columnIndex)
            let columnWidth = cache.columnWidths[columnIndex]

            // Calculate row y position
            let rowY = gridOrigin.y + cache.rowHeight * CGFloat(rowIndex)
                + vSpacing * CGFloat(rowIndex)

            // Get subview's natural size
            let subviewSize = subview.sizeThatFits(.unspecified)

            // Calculate position within cell based on alignment
            var x = columnX
            var y = rowY

            // Horizontal alignment within column
            switch alignment.horizontal {
            case .leading:
                x = columnX
            case .trailing:
                x = columnX + columnWidth - subviewSize.width
            default: // center
                x = columnX + (columnWidth - subviewSize.width) / 2
            }

            // Vertical alignment within row
            switch alignment.vertical {
            case .top:
                y = rowY
            case .bottom:
                y = rowY + cache.rowHeight - subviewSize.height
            default: // center
                y = rowY + (cache.rowHeight - subviewSize.height) / 2
            }

            let position = CGPoint(x: x, y: y)
            subview.place(
                at: position,
                proposal: ProposedViewSize(
                    width: columnWidth,
                    height: cache.rowHeight
                )
            )
        }
    }
}
