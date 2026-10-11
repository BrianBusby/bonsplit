import SwiftUI

/// Draws passive tab surfaces without owning selection or drag behavior.
struct TabItemBackground: View {
    let appearance: BonsplitConfiguration.Appearance
    let isSelected: Bool
    let isHovered: Bool
    let trailingSeparatorBottomInset: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if let style = appearance.tabChromePresentation {
            UnevenRoundedRectangle(topLeadingRadius: style.cornerRadius, topTrailingRadius: style.cornerRadius)
                .fill(isSelected ? style.selectedBackground : isHovered ? style.hoverBackground : .clear)
                .overlay(alignment: .top) {
                    if isSelected {
                        UnevenRoundedRectangle(topLeadingRadius: style.cornerRadius, topTrailingRadius: style.cornerRadius)
                            .strokeBorder(style.indicator, lineWidth: style.indicatorWidth)
                            .mask(alignment: .top) { Rectangle().frame(height: style.cornerRadius) }
                    }
                }
            .animation(reduceMotion ? nil : .timingCurve(style.timingCurve, duration: style.duration), value: isHovered)
        } else {
            ZStack(alignment: .top) {
                if isSelected {
                    Rectangle().fill(TabBarColors.activeTabBackground(for: appearance))
                } else if isHovered {
                    Rectangle().fill(TabBarColors.hoveredTabBackground(for: appearance))
                }
                HStack {
                    Spacer()
                    Rectangle().fill(TabBarColors.separator(for: appearance)).frame(width: 1)
                        .padding(.bottom, max(0, trailingSeparatorBottomInset))
                }
            }
        }
    }
}
