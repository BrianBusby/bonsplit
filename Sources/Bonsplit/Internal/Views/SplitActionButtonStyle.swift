import SwiftUI

struct SplitActionButtonStyle: ButtonStyle {
    let appearance: BonsplitConfiguration.Appearance
    let layout: TabBarLayout

    func makeBody(configuration: Configuration) -> some View {
        if let presentation = appearance.tabChromePresentation {
            TabChromeControlLabel(label: configuration.label, isPressed: configuration.isPressed, presentation: presentation)
        } else {
            configuration.label
                .frame(height: layout.splitActionButtonHeight)
                .contentShape(Rectangle())
                .foregroundStyle(TabBarColors.splitActionIcon(for: appearance, isPressed: configuration.isPressed))
                .opacity(configuration.isPressed ? 0.72 : 1.0)
                .tabBarButtonAnimationsDisabled()
        }
    }
}

