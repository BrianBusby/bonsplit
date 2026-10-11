import SwiftUI

/// Adopts an optional host presentation while retaining the original native button action.
struct TabChromeButtonStyle: ButtonStyle {
    let presentation: TabChromePresentation?

    func makeBody(configuration: Configuration) -> some View {
        if let presentation {
            TabChromeControlLabel(label: configuration.label, isPressed: configuration.isPressed, presentation: presentation)
        } else {
            configuration.label
        }
    }
}
