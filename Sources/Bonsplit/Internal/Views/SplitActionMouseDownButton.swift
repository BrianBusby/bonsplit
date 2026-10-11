import SwiftUI

/// Styles the existing immediate mouse-down action without delaying or duplicating it.
struct SplitActionMouseDownButton<Label: View>: View {
    let presentation: TabChromePresentation?
    let onMouseDown: () -> Void
    @ViewBuilder let label: () -> Label
    @State private var isPressed = false

    var body: some View {
        Group {
            if let presentation {
                TabChromeControlLabel(label: label(), isPressed: isPressed, presentation: presentation)
            } else {
                label().tabBarButtonAnimationsDisabled()
            }
        }
        .overlay(SplitActionMouseDownOverlay(onMouseDown: onMouseDown, onPressedChange: { isPressed = $0 }))
    }
}
