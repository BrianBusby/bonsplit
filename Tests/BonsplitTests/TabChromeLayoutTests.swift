import Foundation
import Testing
@testable import Bonsplit

@Suite
struct TabChromeLayoutTests {
    @Test(arguments: [4, 5])
    func presentationWidthReservesEveryControlBeforeAndAfterMeasurement(buttonCount: Int) {
        let expected = TabBarStyling.splitButtonsLeadingPadding + TabBarStyling.splitButtonsTrailingPadding
            + CGFloat(buttonCount) * 28 + CGFloat(buttonCount - 1) * TabBarStyling.splitButtonsSpacing
        for measured in [CGFloat.zero, expected] {
            let layout = TabBarLayout(tabBarHeight: 30, availableWidth: 320,
                splitButtonCount: buttonCount, splitButtonLaneVisible: true, reservesSplitButtonLane: true,
                measuredSplitButtonLaneWidth: measured, splitActionButtonWidth: 28)
            #expect(layout.fullSplitButtonLaneWidth == expected)
            #expect(layout.visibleSplitButtonLaneWidth == expected)
            #expect(layout.trailingTabContentInset == expected)
            #expect(!layout.splitButtonLaneOverflowsViewport)
        }
    }

    @Test(arguments: [4, 5])
    func absentPresentationRetainsLegacyReservation(buttonCount: Int) {
        let layout = TabBarLayout(tabBarHeight: 30, availableWidth: 320,
            splitButtonCount: buttonCount, splitButtonLaneVisible: true, reservesSplitButtonLane: true)
        let expected = TabBarStyling.splitButtonsLeadingPadding + TabBarStyling.splitButtonsTrailingPadding
            + CGFloat(buttonCount) * 22 + CGFloat(buttonCount - 1) * TabBarStyling.splitButtonsSpacing
        #expect(layout.visibleSplitButtonLaneWidth == expected)
        #expect(!layout.splitButtonLaneOverflowsViewport)
    }
}
