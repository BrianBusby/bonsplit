import SwiftUI

/// Keeps hover and press feedback local to one native chrome control.
struct TabChromeControlLabel<Label: View>: View {
    let label: Label
    let isPressed: Bool
    let presentation: TabChromePresentation
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.isFocused) private var isFocused
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isHovered = false

    var body: some View {
        label
            .frame(minWidth: presentation.minimumHitSize, minHeight: presentation.minimumHitSize)
            .foregroundStyle(presentation.secondaryText)
            .background {
                RoundedRectangle(cornerRadius: presentation.controlRadius)
                    .fill(!isEnabled ? .clear : isPressed ? presentation.pressWash : isHovered ? presentation.hoverWash : .clear)
            }
            .overlay {
                if isFocused && isEnabled {
                    RoundedRectangle(cornerRadius: presentation.controlRadius)
                        .inset(by: -(presentation.focusOffset + presentation.focusWidth))
                        .strokeBorder(presentation.focus, lineWidth: presentation.focusWidth)
                }
            }
            .opacity(isEnabled ? 1 : presentation.disabledOpacity)
            .contentShape(Rectangle())
            .onHover { isHovered = $0 }
            .animation(reduceMotion ? nil : .timingCurve(presentation.timingCurve, duration: presentation.duration), value: isHovered)
            .animation(reduceMotion ? nil : .timingCurve(presentation.timingCurve, duration: presentation.duration), value: isPressed)
    }
}
