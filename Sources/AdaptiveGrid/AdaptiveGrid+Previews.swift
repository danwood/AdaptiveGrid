import SwiftUI

#if compiler(>=6)
private struct GridCellModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(color.opacity(0.2))
            .overlay {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color.opacity(0.5), lineWidth: 1)
            }
    }
}

private extension View {
    func gridCell(_ color: Color = .blue) -> some View {
        modifier(GridCellModifier(color: color))
    }
}

private let sampleTexts = ["Short", "Medium Text", "Very Long Label Here", "Tiny", "Another One", "X", "This one is rather quite long", "123"]

#Preview("Equal Width - 300pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.blue)
        }
    }
    .equalWidth()
    .frame(width: 300)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Equal Width - 500pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.blue)
        }
    }
    .equalWidth()
    .frame(width: 500)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Equal Width - 700pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.blue)
        }
    }
    .equalWidth()
    .frame(width: 700)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Adaptive Width - 300pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.green)
        }
    }
    .frame(width: 300)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Adaptive Width - 500pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.green)
        }
    }
    .frame(width: 500)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Adaptive Width - 700pt") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(sampleTexts, id: \.self) { text in
            Text(text).gridCell(.green)
        }
    }
    .frame(width: 700)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Mixed Content - Equal") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        Button("Action") {}.gridCell(.orange)
        Text("Label").gridCell(.orange)
        Image(systemName: "star.fill").gridCell(.yellow)
        Text("Longer Longer Text").gridCell(.purple)
        Text("Short").gridCell(.pink)
    }
    .equalWidth()
    .frame(width: 300)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Mixed Content - Adaptive") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        Button("Action") {}.gridCell(.orange)
        Text("Label").gridCell(.orange)
        Image(systemName: "star.fill").gridCell(.yellow)
        Text("Longer Longer Text").gridCell(.purple)
        Text("Short").gridCell(.pink)
    }
    .frame(width: 300)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Fixed Size - Equal") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(1...10, id: \.self) { number in
			if number == 3 {
				Text("Longer item here").gridCell(.green)
			} else {
				Text("Item \(number)").gridCell(.cyan)
			}
        }
    }
    .equalWidth()
    .frame(width: 500)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Fixed Size - Adaptive") {
    AdaptiveGrid(horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(1...10, id: \.self) { number in
			if number == 3 {
				Text("Longer item here").gridCell(.green)
			} else {
				Text("Item \(number)").gridCell(.cyan)
			}
        }
    }
    .frame(width: 500)
    .padding()
    .background(Color.gray.opacity(0.1))
}

private let alignmentTexts = ["A A A A A A A", "BB", "CCC CCC CCC CCC", "D", "EE", "FFF", "GGGGGGGGGGG"]

#Preview("Alignment - Leading") {
    AdaptiveGrid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(alignmentTexts, id: \.self) { text in
            Text(text).gridCell(.red)
        }
    }
    .frame(width: 400)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Alignment - Center") {
    AdaptiveGrid(alignment: .center, horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(alignmentTexts, id: \.self) { text in
            Text(text).gridCell(.blue)
        }
    }
    .frame(width: 400)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Alignment - Trailing") {
    AdaptiveGrid(alignment: .trailing, horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(alignmentTexts, id: \.self) { text in
            Text(text).gridCell(.green)
        }
    }
    .frame(width: 400)
    .padding()
    .background(Color.gray.opacity(0.1))
}

private let tags = [
    "SwiftUI", "iOS", "macOS", "Layout", "Grid",
    "Adaptive", "Custom", "View", "Protocol", "Design",
]

#Preview("Tags - Adaptive") {
    AdaptiveGrid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(tags, id: \.self) { tag in
            Text(tag)
                .font(.title)
                .gridCell(.indigo)
        }
    }
    .frame(width: 400)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#Preview("Tags - Equal Width") {
    AdaptiveGrid(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 8) {
        ForEach(tags, id: \.self) { tag in
            Text(tag)
                .font(.title)
                .gridCell(.indigo)
        }
    }
    .equalWidth()
    .frame(width: 400)
    .padding()
    .background(Color.gray.opacity(0.1))
}

#endif
