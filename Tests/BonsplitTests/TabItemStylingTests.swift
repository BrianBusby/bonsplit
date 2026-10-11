import AppKit
import Testing
@testable import Bonsplit

@Suite @MainActor
struct TabItemStylingTests {
    @Test func testIconSaturationKeepsRasterFaviconInColorWhenInactive() {
        #expect(TabItemStyling().iconSaturation(hasRasterIcon: true, tabSaturation: 0.0) == 1.0)
    }

    @Test func testIconSaturationStillDesaturatesSymbolIconsWhenInactive() {
        #expect(TabItemStyling().iconSaturation(hasRasterIcon: false, tabSaturation: 0.0) == 0.0)
    }

    @Test func testResolvedFaviconImageUsesIncomingDataWhenDecodable() {
        let existing = NSImage(size: NSSize(width: 12, height: 12))
        let incoming = NSImage(size: NSSize(width: 16, height: 16))
        incoming.lockFocus()
        NSColor.systemBlue.setFill()
        NSBezierPath(rect: NSRect(x: 0, y: 0, width: 16, height: 16)).fill()
        incoming.unlockFocus()
        let data = incoming.tiffRepresentation

        let resolved = TabItemStyling().resolvedFaviconImage(existing: existing, incomingData: data)
        #expect(resolved != nil)
        #expect(!(resolved === existing))
    }

    @Test func testResolvedFaviconImageKeepsExistingImageWhenIncomingDataIsInvalid() {
        let existing = NSImage(size: NSSize(width: 16, height: 16))
        let invalidData = Data([0x00, 0x11, 0x22, 0x33])

        let resolved = TabItemStyling().resolvedFaviconImage(existing: existing, incomingData: invalidData)
        #expect(resolved === existing)
    }

    @Test func testResolvedFaviconImageClearsWhenIncomingDataIsNil() {
        let existing = NSImage(size: NSSize(width: 16, height: 16))
        let resolved = TabItemStyling().resolvedFaviconImage(existing: existing, incomingData: nil)
        #expect(resolved == nil)
    }

    @Test func testSelectedTabNeverShowsHoverBackground() {
        #expect(!(TabItemStyling().shouldShowHoverBackground(isHovered: true, isSelected: true)))
        #expect(TabItemStyling().shouldShowHoverBackground(isHovered: true, isSelected: false))
        #expect(!(TabItemStyling().shouldShowHoverBackground(isHovered: false, isSelected: false)))
    }

    @Test func testTabWidthRangeKeepsCompactVisualMinimum() {
        let range = TabItemStyling(appearance: BonsplitConfiguration.Appearance(
            tabMinWidth: 140, tabMaxWidth: 220)).tabWidthRange

        #expect(range.lowerBound == TabBarMetrics.tabMinWidth)
        #expect(range.upperBound == 220)
    }

    @Test func testIconOnlyPinnedRequiresPinnedBrowserTab() {
        // Pinned browser tabs collapse to icon-only; everything else keeps its title.
        #expect(TabItemStyling().isIconOnlyPinned(isPinned: true, kind: "browser"))
        #expect(!(TabItemStyling().isIconOnlyPinned(isPinned: false, kind: "browser")))
        #expect(!(TabItemStyling().isIconOnlyPinned(isPinned: true, kind: "terminal")))
        #expect(!(TabItemStyling().isIconOnlyPinned(isPinned: true, kind: nil)))
        #expect(!(TabItemStyling().isIconOnlyPinned(isPinned: false, kind: "terminal")))
    }

    @Test func testIconOnlyPinnedKindMatchesBrowserTabKindConstant() {
        #expect(TabItemStyling().isIconOnlyPinned(isPinned: true, kind: TabItemStyling().browserTabKind))
    }

    @Test func testPinnedIconOnlyWidthHugsIconWithPadding() {
        let width = TabItemStyling().pinnedIconOnlyWidth(iconSlotSize: 14, horizontalPadding: 6)

        // Favicon slot + symmetric padding + breathing room.
        let expected: CGFloat = ceil(CGFloat(14 + 6 * 2 + 6))
        #expect(width == expected)
        // The whole point: a pinned browser tab is narrower than the standard tab minimum.
        #expect(width < TabBarMetrics.tabMinWidth)
    }

    @Test func testPinnedIconOnlyWidthClampsDegenerateInputs() {
        // Non-positive icon/padding inputs are floored so the chip never collapses to zero.
        let width = TabItemStyling().pinnedIconOnlyWidth(iconSlotSize: 0, horizontalPadding: -10)
        let expected: CGFloat = ceil(CGFloat(1 + 0 + 6))
        #expect(width == expected)
        #expect(width > 0)
    }

    @Test func testPinnedIconOnlyWidthKeepsBaseWhenNoShortcutHintReserved() {
        let base = TabItemStyling().pinnedIconOnlyWidth(iconSlotSize: 14, horizontalPadding: 6)
        let reserved = TabItemStyling().pinnedIconOnlyWidth(
            iconSlotSize: 14,
            horizontalPadding: 6,
            reservedShortcutHintWidth: nil
        )
        #expect(reserved == base)
    }

    @Test func testPinnedIconOnlyWidthReservesShortcutHintPillToAvoidLayoutShift() {
        // A wide hint pill expands the chip so the pill (shown only on modifier-hold)
        // always fits without resizing the tab.
        let pill: CGFloat = 30
        let width = TabItemStyling().pinnedIconOnlyWidth(
            iconSlotSize: 14,
            horizontalPadding: 6,
            reservedShortcutHintWidth: pill
        )
        #expect(width == ceil(pill + 6 * 2))
        #expect(width > TabItemStyling().pinnedIconOnlyWidth(iconSlotSize: 14, horizontalPadding: 6))
    }

    @Test func testPinnedIconOnlyWidthKeepsBaseWhenReservedHintIsNarrow() {
        // A narrow hint that fits inside the base chip must not shrink the tab.
        let base = TabItemStyling().pinnedIconOnlyWidth(iconSlotSize: 14, horizontalPadding: 6)
        let width = TabItemStyling().pinnedIconOnlyWidth(
            iconSlotSize: 14,
            horizontalPadding: 6,
            reservedShortcutHintWidth: 1
        )
        #expect(width == base)
    }

    @Test func testTabShortcutHintSlotWidthDoesNotChangeWithFocus() {
        let label = "⌃9"
        let accessorySlotSize: CGFloat = 18

        let focusedWidth = TabItemStyling().reservedShortcutHintSlotWidth(
            shortcutHintLabel: label,
            tabShortcutHintsEnabled: true,
            isFocused: true,
            accessorySlotSize: accessorySlotSize,
            xOffset: 0
        )
        let unfocusedWidth = TabItemStyling().reservedShortcutHintSlotWidth(
            shortcutHintLabel: label,
            tabShortcutHintsEnabled: true,
            isFocused: false,
            accessorySlotSize: accessorySlotSize,
            xOffset: 0
        )

        // Focusing a pane must not resize its tabs: the reserved width is
        // focus-independent, so the tab bar never shifts as focus moves.
        #expect(focusedWidth == unfocusedWidth)
    }

    @Test func testTabShortcutHintSlotReservesOnlyAccessoryWidth() {
        // The trailing accessory reserves just the close-button width. The
        // shortcut-hint pill overlays that slot (mutually exclusive with the
        // close button, non-interactive) instead of widening the tab, so a tab
        // carrying a ⌃/⌘ digit is no wider than one without. Prevents the
        // "digit tabs are permanently ~11pt too wide" regression.
        let label = "⌃9"
        let accessorySlotSize: CGFloat = 18

        for isFocused in [true, false] {
            let width = TabItemStyling().reservedShortcutHintSlotWidth(
                shortcutHintLabel: label,
                tabShortcutHintsEnabled: true,
                isFocused: isFocused,
                accessorySlotSize: accessorySlotSize,
                xOffset: 0
            )
            #expect(width == accessorySlotSize)
        }
    }

    @Test func testTabShortcutHintSlotWidthCollapsesWhenHintsDisabled() {
        let label = "⌃9"
        let accessorySlotSize: CGFloat = 18

        for isFocused in [true, false] {
            let width = TabItemStyling().reservedShortcutHintSlotWidth(
                shortcutHintLabel: label,
                tabShortcutHintsEnabled: false,
                isFocused: isFocused,
                accessorySlotSize: accessorySlotSize,
                xOffset: 0
            )
            // With hints disabled no hint width is reserved, regardless of focus.
            #expect(width == accessorySlotSize)
        }
    }

    @Test func testTabShortcutHintWidthUsesSharedPillPadding() {
        // Still used to reserve the hint pill on icon-only pinned browser tabs.
        let label = "⌘9"
        let textWidth = (label as NSString).size(
            withAttributes: TabControlShortcutHintStyle.measurementAttributes
        ).width

        #expect(TabItemStyling().shortcutHintWidth(for: label) == ceil(textWidth) + (TabControlShortcutHintStyle.horizontalPadding * 2))
    }
}
