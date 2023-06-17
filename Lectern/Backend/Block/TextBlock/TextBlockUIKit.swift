//
//  TextBlockUIKit.swift
//  Lectern
//
//  Created by Paul Wong on 6/17/23.
//

import SwiftUI
import Observation

class UITextViewWrapper: UITextView {

    let ref: TextBlockUIKit
    var deleteAction: (() -> ())? = nil

    internal init(ref: TextBlockUIKit) {
        self.ref = ref
        super.init(frame: .zero, textContainer: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func deleteBackward() {

        if self.selectedRange == NSRange(location: 0, length: 0) {
            self.deleteAction?()
            self.ref.cm.ensureGhostBlockExists()
        }

        super.deleteBackward()
    }

    override func becomeFirstResponder() -> Bool {
        ref.focus?.wrappedValue = true
        return super.becomeFirstResponder()
    }

    override func resignFirstResponder() -> Bool {
        ref.focus?.wrappedValue = false
        return super.resignFirstResponder()
    }
}


struct TextBlockUIKit: UIViewRepresentable {

    var block: Block
    var cm: ContentManager
    var focus: Binding<Bool>?

    @Binding var height: CGFloat

    var disabled: Bool = false
    var newLineAction: ((NSRange) -> Void)? = nil
    var deleteAction: (() -> Void)? = nil


    func makeUIView(context: Context) -> UITextViewWrapper {
        let textView = UITextViewWrapper(ref: self)

        textView.isUserInteractionEnabled = !disabled
        textView.deleteAction = deleteAction
        textView.delegate = context.coordinator
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        // Placeholder
//        if block.text == "" {
//            textView.attributedText = TextStyleStandard.body(
//                Block(id: block.id, type: .textBlock, text: TextStyleStandard.INIT)
//            )
//            textView.textColor = UIColor.white.withAlphaComponent(0.9)
//        } else {
//        textView.textColor = UIColor.white.withAlphaComponent(0.9)

        if block.textType == .header {
            textView.attributedText = TextStyleStandard.header(block)
        } else {
            textView.attributedText = TextStyleStandard.body(block)
        }
//        }

        textView.textContainer.lineFragmentPadding = 0
        textView.isScrollEnabled = false
        textView.backgroundColor = nil

        return textView
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextViewWrapper, context: Context) -> CGSize? {
        let size = uiView.sizeThatFits(CGSize(width: proposal.width ?? 0, height: 0))
        return CGSize(width: proposal.width ?? 0, height: size.height)
    }

    func updateUIView(_ uiView: UITextViewWrapper, context: Context) {
        withObservationTracking {
            if block.textType == .header {
                uiView.attributedText = TextStyleStandard.header(block)
            } else {
                uiView.attributedText = TextStyleStandard.body(block)
            }

            DispatchQueue.main.async {
                uiView.isUserInteractionEnabled = !disabled
                updateFocus(uiView, context: context)
            }
        } onChange: {

        }


    }

    private func updateFocus(_ view: UITextView, context: Context) {
        guard let focus = focus?.wrappedValue else { return }

        if focus,
           view.window != nil,
           !view.isFirstResponder,
           view.canBecomeFirstResponder,
           context.environment.isEnabled
        {
            view.becomeFirstResponder()
            view.selectedRange = cm.selectState ?? NSRange(location: view.text.count, length: 0)
        } else if !focus, view.isFirstResponder {
            //view.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        var swiftUIParent: TextBlockUIKit

        init(_ parent: TextBlockUIKit) {
            self.swiftUIParent = parent
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == UIColor.white.withAlphaComponent(0.9) {
                swiftUIParent.block.text = ""
                textView.text = ""
                textView.textColor = UIColor.white.withAlphaComponent(0.9)
                textView.font = UIFont.systemFont(ofSize: 22)
            }
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
//            if textView.text == "" {
//                textView.text = TextStyleStandard.PLACEHOLDER
//                textView.font = UIFont.systemFont(ofSize: 17)
//                textView.textColor = .secondaryLabel
//            }
        }

        public func textViewDidChange(_ textView: UITextView) {
            self.swiftUIParent.block.text = textView.text
            self.swiftUIParent.cm.ensureGhostBlockExists()

//            DispatchQueue.main.async { [weak self] in
//                self?.swiftUIParent.height = sw
//            }
        }

        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                self.swiftUIParent.newLineAction?(range)
                return false
            }
            return true
        }
    }
}
