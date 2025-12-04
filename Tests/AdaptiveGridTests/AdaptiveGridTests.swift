import XCTest
import SwiftUI
@testable import AdaptiveGrid

@MainActor
final class AdaptiveGridTests: XCTestCase {
    func testAdaptiveGridInitialization() {
        let grid = AdaptiveGrid {
            Text("Test")
        }

        XCTAssertNotNil(grid)
    }

    func testAdaptiveGridWithCustomSpacing() {
        let grid = AdaptiveGrid(
            horizontalSpacing: 16,
            verticalSpacing: 12
        ) {
            Text("Test")
        }

        XCTAssertNotNil(grid)
    }

    func testAdaptiveGridWithAlignment() {
        let grid = AdaptiveGrid(alignment: .leading) {
            Text("Test")
        }

        XCTAssertNotNil(grid)
    }

    func testEqualWidthModifier() {
        let grid = AdaptiveGrid {
            Text("Test")
        }
        .equalWidth()

        XCTAssertNotNil(grid)
    }

    nonisolated func testEnvironmentKeyDefaultValue() {
        let environment = EnvironmentValues()
        XCTAssertFalse(environment.equalWidth)
    }

    func testLayoutCacheInitialization() {
        let cache = AdaptiveGridLayout.LayoutCache(
            equalWidth: false,
            columnCount: 3,
            columnWidths: [100, 100, 100],
            rowHeight: 50,
            totalSize: CGSize(width: 300, height: 100)
        )

        XCTAssertEqual(cache.columnCount, 3)
        XCTAssertEqual(cache.columnWidths.count, 3)
        XCTAssertEqual(cache.rowHeight, 50)
        XCTAssertFalse(cache.equalWidth)
    }
}
