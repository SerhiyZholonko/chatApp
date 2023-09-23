//
//  CustomeInputView.swift
//  chatApp
//
//  Created by apple on 12.09.2023.
//

import UIKit

protocol CustomeInputViewDelegate: AnyObject {
    func inputView(_ view: CustomeInputView, wantUploadMessage message: String)
    func custonViewForAttach(_ view: CustomeInputView)
    func inputViewForAudio(_ view: CustomeInputView, audioURL: URL)
}

class CustomeInputView: UIView {
    //MARK: - Properties
    weak var delegate: CustomeInputViewDelegate?
    
    var duration: CGFloat = 0.0
    var timer: Timer!
    var recorder = AKAudioRecorder.shared
    
    let inputTextView = InputTextView()
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return view
    }()
    
    private lazy var postBackgroundColor: CustomImageView = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hanelePostButton))
        let iv = CustomImageView(width: 40, height: 40, cornerRedius: 20, background: .systemGreen)
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        iv.isHidden = true
        return iv
    }()
    private lazy var postButton: UIButton = {
        let button = UIButton (type: .system)
        button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.setDimensions (height: 28, width: 28)
        button.addTarget(self, action: #selector(hanelePostButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [inputTextView, postBackgroundColor, attachButton, recordButton])
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()
    private lazy var  attachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "paperclip.circle"), for: .normal)
        button.setDimensions(height: 40, width: 40)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(handleAttchButton), for: .touchUpInside)
        return button
    }()
    
    //TODO: ~ Record View
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .label
        button.setDimensions (height: 40, width: 100)
        button.addTarget (self, action: #selector (handleCancelButton), for: .touchUpInside)
        return button
    }()
    private lazy var  recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "mic.circle"), for: .normal)
        button.setDimensions(height: 40, width: 40)
        button.tintColor = .systemGreen
        button.addTarget(self, action: #selector(handleRecordButton), for: .touchUpInside)
        return button
    }()
    private lazy var sendRecordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.setDimensions(height: 40, width: 100)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSendButtom), for: .touchUpInside)
        return button
    }()
    private lazy var recordStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cancelButton, timerLabel, sendRecordButton])
        sv.axis = .horizontal
        sv.alignment = .center
        sv.isHidden = true
        return sv
    }()
    private let timerLabel = CustomLabel(textLabel: "00:00")
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        NotificationCenter.default.addObserver(self,selector:#selector(handleTextDidChange),
                                               name: InputTextView.textDidChangeNotification, object:
                                                nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    //MARK: - Functions
    func clearTextView() {
        inputTextView.text = ""
        inputTextView.placeHolderLabel.isHidden = false
    }
    private func configureUI() {
        backgroundColor = .systemBackground
        autoresizingMask = .flexibleHeight
        addSubview(stackView)
        stackView.anchor(top: topAnchor,  right: rightAnchor,  paddingRight: 5)
        addSubview (postButton)
        postButton.center(inView: postBackgroundColor)
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postBackgroundColor.leftAnchor , paddingTop: 12, paddingLeft: 8, paddingBottom: 5, paddingRight: 8)
        addSubview(dividerView)
        dividerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
        addSubview(recordStackView)
        recordStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 12, paddingRight: 12)
    }
    //MARK: -  @objc
    @objc func hanelePostButton() {
        guard !inputTextView.text.isEmpty else { return }
        delegate?.inputView(self, wantUploadMessage: inputTextView.text)
    }
    @objc private func handleAttchButton() {
        delegate?.custonViewForAttach(self)
    }
    
    @objc private func handleTextDidChange() {
        let isTextEmpty = inputTextView.text.isEmpty || inputTextView.text == ""
        postButton.isHidden = isTextEmpty
        postBackgroundColor.isHidden = isTextEmpty
        attachButton.isHidden = !isTextEmpty
        recordButton.isHidden = !isTextEmpty
    }
    
    
}

//MARK: -
extension CustomeInputView {
    @objc private func handleRecordButton() {
        stackView.isHidden = true
        recordStackView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            recorder.myRecordings.removeAll()
            recorder.record()
            setTimer()
            
        }
       
    }
    @objc private func handleSendButtom() {
        recorder.stopRecording()
        //TODO: - take the record audio file to upload
        let name = recorder.getRecordings.last ?? ""
        guard let audioURL = recorder.getAudioURL(name: name) else { return }
        delegate?.inputViewForAudio(self, audioURL: audioURL)
        
        stackView.isHidden = true
        recordStackView.isHidden = false
    }
    @objc private func handleCancelButton() {
        stackView.isHidden = false
        recordStackView.isHidden = true
    }
    
     //MARK: - funnc
    private func setTimer() {
       timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }

    @objc private func updateTimer() {
        if recorder.isRecording && !recorder.isPlaying {
            duration += 1
            self.timerLabel.text = duration.timeStringFormatter
        } else {
            timer.invalidate()
            duration = 0
            self.timerLabel.text = "00:00"
        }
    }
}
