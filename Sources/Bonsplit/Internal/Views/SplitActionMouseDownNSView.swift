import AppKit

final class SplitActionMouseDownNSView: NSView {
    var onMouseDown: (() -> Void)?
    var onPressedChange: ((Bool) -> Void)?

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override func mouseDown(with event: NSEvent) {
        onPressedChange?(true)
        onMouseDown?()
    }
    override func mouseUp(with event: NSEvent) { onPressedChange?(false) }
    override func viewWillMove(toWindow newWindow: NSWindow?) {
        if newWindow !== window { onPressedChange?(false) }
        super.viewWillMove(toWindow: newWindow)
    }
}

