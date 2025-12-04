import SwiftUI

extension EnvironmentValues {
    @Entry var equalWidth: Bool = false
}

extension View {
    /// Configures the AdaptiveGrid to use equal width columns.
    ///
    /// When applied to an AdaptiveGrid, all columns will have the same width,
    /// determined by the widest subview in the grid.
    public func equalWidth() -> some View {
        environment(\.equalWidth, true)
    }
}
