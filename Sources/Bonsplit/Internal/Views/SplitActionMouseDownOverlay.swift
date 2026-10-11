import SwiftUI
import AppKit

struct SplitActionMouseDownOverlay: NSViewRepresentable {
    let onMouseDown: () -> Void
    let onPressedChange: (Bool) -> Void

    func makeNSView(context: Context) -> SplitActionMouseDownNSView {
        let view = SplitActionMouseDownNSView()
        view.onMouseDown = onMouseDown
        view.onPressedChange = onPressedChange
        return view
    }

    func updateNSView(_ nsView: SplitActionMouseDownNSView, context: Context) {
        nsView.onMouseDown = onMouseDown
        nsView.onPressedChange = onPressedChange
    }
}

