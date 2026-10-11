import SwiftUI
import AppKit

/// Resolves immutable tab presentation and measurement inputs.
struct TabItemStyling {
    let appearance: BonsplitConfiguration.Appearance

    init(appearance: BonsplitConfiguration.Appearance = .init()) {
        self.appearance = appearance
    }

    var fontScale: CGFloat { max(0.1, appearance.tabTitleFontSize / TabBarMetrics.titleFontSize) }
    var iconSize: CGFloat { TabBarMetrics.iconSize * fontScale }
    var closeIconSize: CGFloat { TabBarMetrics.closeIconSize * fontScale }
    var contentSpacing: CGFloat { TabBarMetrics.contentSpacing * fontScale }

    func iconSaturation(hasRasterIcon: Bool, tabSaturation: Double) -> Double {
        hasRasterIcon ? 1.0 : tabSaturation
    }

    func shouldShowHoverBackground(isHovered: Bool, isSelected: Bool) -> Bool {
        isHovered && !isSelected
    }

    var tabWidthRange: ClosedRange<CGFloat> {
        let minimum = max(1, TabBarMetrics.tabMinWidth)
        let maximum = max(minimum, appearance.tabMaxWidth)
        return minimum...maximum
    }

    /// Natural width of the ⌃/⌘ shortcut-hint pill for `label`. The standard tab
    /// strip overlays this pill without reserving width, but icon-only pinned
    /// browser tabs (which have no close button to overlay) still reserve it so
    /// holding the modifier never resizes the pinned chip.
    func shortcutHintWidth(for label: String) -> CGFloat {
        let textWidth = (label as NSString).size(withAttributes: TabControlShortcutHintStyle.measurementAttributes).width
        return ceil(textWidth) + (TabControlShortcutHintStyle.horizontalPadding * 2)
    }

    /// Width of a tab's trailing accessory slot.
    ///
    /// The slot reserves only the close-button (`accessorySlotSize`) width and
    /// never widens for the keyboard-shortcut hint. The ⌃/⌘ digit pill overlays
    /// this same slot (it is mutually exclusive with the close button and
    /// non-interactive), rendering at its natural size within the tab's trailing
    /// padding instead of pushing layout. Two consequences, both intended:
    ///   1. A tab carrying a ⌃/⌘ digit is exactly as wide as one without, so the
    ///      hint feature no longer makes tabs wider.
    ///   2. The reserved width is a constant, independent of `isFocused`,
    ///      `tabShortcutHintsEnabled`, the label, and the debug `xOffset`, so the
    ///      tab bar never shifts when a pane gains/loses focus or ⌃/⌘ is held.
    /// The parameters are accepted so the call site can pass the live state, but
    /// none of them may affect the result.
    func reservedShortcutHintSlotWidth(
        shortcutHintLabel: String?,
        tabShortcutHintsEnabled: Bool,
        isFocused: Bool,
        accessorySlotSize: CGFloat,
        xOffset: Double
    ) -> CGFloat {
        // Deliberately ignores every hint/focus input: the pill overlays the
        // accessory slot, so the reserved layout width is always just the
        // close-button size. See the doc comment above.
        _ = (shortcutHintLabel, tabShortcutHintsEnabled, isFocused, xOffset)
        return accessorySlotSize
    }

    func resolvedFaviconImage(existing: NSImage?, incomingData: Data?) -> NSImage? {
        guard let incomingData else { return nil }
        if let decoded = NSImage(data: incomingData) {
            // Favicon bitmaps must never be treated as template/tintable symbols.
            decoded.isTemplate = false
            return decoded
        }
        return existing
    }

    /// Host-defined tab kind identifier for browser surfaces. Pinned browser tabs
    /// collapse to an icon-only chip (favicon only) to mirror pinned tabs in macOS
    /// browsers, freeing tab-bar space for long-lived utility pages.
    let browserTabKind = "browser"

    /// Whether a tab should render in the compact icon-only style reserved for
    /// pinned browser surfaces. Terminal and other kinds keep their titled layout
    /// when pinned because they have no distinguishing favicon to collapse to.
    func isIconOnlyPinned(isPinned: Bool, kind: String?) -> Bool {
        isPinned && kind == browserTabKind
    }

    /// Fixed width for an icon-only pinned browser tab: the favicon slot plus the
    /// tab's symmetric horizontal padding and a little breathing room, so the tab
    /// shrinks to roughly a square chip hugging its icon.
    func pinnedIconOnlyWidth(iconSlotSize: CGFloat, horizontalPadding: CGFloat) -> CGFloat {
        let icon = max(1, iconSlotSize)
        let padding = max(0, horizontalPadding)
        return ceil(icon + padding * 2 + 6)
    }

    /// Icon-only pinned width that also reserves room for the control-shortcut hint
    /// pill when one can be shown, so holding the modifier never resizes the tab.
    /// Pass `reservedShortcutHintWidth == nil` when the tab has no hint to reserve.
    func pinnedIconOnlyWidth(
        iconSlotSize: CGFloat,
        horizontalPadding: CGFloat,
        reservedShortcutHintWidth: CGFloat?
    ) -> CGFloat {
        let base = pinnedIconOnlyWidth(iconSlotSize: iconSlotSize, horizontalPadding: horizontalPadding)
        guard let reservedShortcutHintWidth else { return base }
        let reserved = ceil(max(0, reservedShortcutHintWidth) + max(0, horizontalPadding) * 2)
        return max(base, reserved)
    }
}

