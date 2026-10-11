import SwiftUI

/// Optional host-owned tab chrome presentation; nil retains Bonsplit’s native defaults.
public struct TabChromePresentation: Sendable, Equatable {
    /// Selected tab surface.
    public var selectedBackground: Color
    /// Unselected tab hover surface.
    public var hoverBackground: Color
    /// Selected tab and active icon foreground.
    public var primaryText: Color
    /// Inactive tab and resting icon foreground.
    public var secondaryText: Color
    /// Selected tab top indicator.
    public var indicator: Color
    /// Subtle separator and hint border.
    public var edge: Color
    /// Flat control hover wash.
    public var hoverWash: Color
    /// Flat control pressed wash.
    public var pressWash: Color
    /// Native keyboard focus outline.
    public var focus: Color
    /// Opaque shortcut hint surface.
    public var hintBackground: Color
    /// Selected tab top corner radius.
    public var cornerRadius: CGFloat
    /// Flat control corner radius.
    public var controlRadius: CGFloat
    /// Minimum control width and height.
    public var minimumHitSize: CGFloat
    /// Selected top indicator thickness.
    public var indicatorWidth: CGFloat
    /// Keyboard focus outline thickness.
    public var focusWidth: CGFloat
    /// Keyboard focus outline outset.
    public var focusOffset: CGFloat
    /// Disabled control opacity.
    public var disabledOpacity: Double
    /// Control state transition duration.
    public var duration: Double
    /// Control transition curve.
    public var timingCurve: UnitCurve

    /// Creates a complete palette and geometry without changing tab actions or identity.
    /// - Parameters:
    ///   - selectedBackground: Selected tab surface.
    ///   - hoverBackground: Unselected tab hover surface.
    ///   - primaryText: Selected tab and active icon foreground.
    ///   - secondaryText: Inactive tab and resting icon foreground.
    ///   - indicator: Selected tab top indicator.
    ///   - edge: Subtle separator and hint border.
    ///   - hoverWash: Flat control hover wash.
    ///   - pressWash: Flat control pressed wash.
    ///   - focus: Native keyboard focus outline.
    ///   - hintBackground: Opaque shortcut hint surface.
    ///   - cornerRadius: Selected tab top corner radius.
    ///   - controlRadius: Flat control corner radius.
    ///   - minimumHitSize: Minimum control width and height.
    ///   - indicatorWidth: Selected top indicator thickness.
    ///   - focusWidth: Keyboard focus outline thickness.
    ///   - focusOffset: Keyboard focus outline outset.
    ///   - disabledOpacity: Disabled control opacity.
    ///   - duration: Control state transition duration.
    ///   - timingCurve: Control transition curve.
    public init(
        selectedBackground: Color,
        hoverBackground: Color,
        primaryText: Color,
        secondaryText: Color,
        indicator: Color,
        edge: Color,
        hoverWash: Color,
        pressWash: Color,
        focus: Color,
        hintBackground: Color,
        cornerRadius: CGFloat,
        controlRadius: CGFloat,
        minimumHitSize: CGFloat,
        indicatorWidth: CGFloat,
        focusWidth: CGFloat,
        focusOffset: CGFloat,
        disabledOpacity: Double,
        duration: Double,
        timingCurve: UnitCurve
    ) {
        self.selectedBackground = selectedBackground
        self.hoverBackground = hoverBackground
        self.primaryText = primaryText
        self.secondaryText = secondaryText
        self.indicator = indicator
        self.edge = edge
        self.hoverWash = hoverWash
        self.pressWash = pressWash
        self.focus = focus
        self.hintBackground = hintBackground
        self.cornerRadius = cornerRadius
        self.controlRadius = controlRadius
        self.minimumHitSize = minimumHitSize
        self.indicatorWidth = indicatorWidth
        self.focusWidth = focusWidth
        self.focusOffset = focusOffset
        self.disabledOpacity = disabledOpacity
        self.duration = duration
        self.timingCurve = timingCurve
    }
}
