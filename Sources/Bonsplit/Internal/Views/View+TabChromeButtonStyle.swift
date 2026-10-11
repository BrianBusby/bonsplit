import SwiftUI

extension View {
    /// Retains the original primitive plain style when no host presentation exists.
    @ViewBuilder
    func tabChromeButtonStyle(_ presentation: TabChromePresentation?) -> some View {
        if let presentation {
            buttonStyle(TabChromeButtonStyle(presentation: presentation))
        } else {
            buttonStyle(.plain)
        }
    }
}
