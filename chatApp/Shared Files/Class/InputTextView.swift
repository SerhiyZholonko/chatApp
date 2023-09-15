//
//  InputTextView.swift
//  chatApp
//
//  Created by apple on 12.09.2023.
import UIKit

class InputTextView: UITextView {
    //MARK: - Properties
    let placeHolderLabel = CustomLabel(textLabel: "Type your message...", textColorLabel: .lightGray)

    //MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        autoresizingMask = .flexibleHeight
        configureUI()
        delegate = self // Set the delegate to self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
        delegate = self // Set the delegate to self
    }

    //MARK: - Functions
    private func configureUI() {
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.cornerRadius = 20
        isScrollEnabled = false
        font = .systemFont(ofSize: 16)
        textContainerInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)

        
        addSubview(placeHolderLabel)
        placeHolderLabel.centerY(inView: self, leftAnchor: leftAnchor, rightAnchor: rightAnchor, paddingLeft: 16, paddingRight: 5)

        // Add an observer to track text changes and adjust the content size
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // Function to calculate and set the intrinsic content size based on content
    @objc private func textDidChange() {
          placeHolderLabel.isHidden = !text.isEmpty
          self.invalidateIntrinsicContentSize()
      }

    override var intrinsicContentSize: CGSize {
        let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
        let estimatedSize = sizeThatFits(size)
        return estimatedSize
    }
}


//MARK: - UITextViewDelegate
extension InputTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Editing has begun, hide the placeholder label
        placeHolderLabel.isHidden = true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        // Editing has ended, show the placeholder label if text is empty
        placeHolderLabel.isHidden = !text.isEmpty
    }
}
