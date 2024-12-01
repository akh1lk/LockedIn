//
//  SelectPhotoView.swift
//  LockedIn
//
//  Created by Gabriel Castillo on 11/30/24.
//

import UIKit

protocol SelectPhotoViewDelegate {
    func addImageTapped()
}

class SelectPhotoView: UIView {

    // MARK: - UI Components
    private let heading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Bold", size: 32)
        label.text = "Pick a Photo"
        return label
    }()
    
    private let subheading: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "GaretW05-Regular", size: 16)
        label.text = "Upload a photo of yourself so people can see who you are!"
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add-image-small"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .palette.offBlack.withAlphaComponent(0.5)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.backgroundColor = .palette.offWhite
        button.layer.borderColor = UIColor.palette.offWhite.cgColor
        button.layer.borderWidth = 10
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var selectNewPhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select New Photo", for: .normal)
        button.setTitleColor(.palette.offBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "GaretW05-Bold", size: 16)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.backgroundColor = .palette.offWhite
        button.addTarget(self, action: #selector(addImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Data
    var parent: SetupAccountVC?
    var delegate: SelectPhotoViewDelegate?
    var selectedImage = false
    
    // MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        selectNewPhotoButton.isHidden = true
        
        self.addSubview(heading)
        heading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(subheading)
        subheading.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(addImageButton)
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(selectNewPhotoButton)
        selectNewPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heading.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            heading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            subheading.topAnchor.constraint(equalTo: heading.bottomAnchor, constant: 12),
            subheading.widthAnchor.constraint(equalToConstant: 250),
            subheading.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            addImageButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5),
            addImageButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75),
            addImageButton.topAnchor.constraint(equalTo: self.subheading.bottomAnchor, constant: 30),
            addImageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            selectNewPhotoButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            selectNewPhotoButton.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20),
            selectNewPhotoButton.widthAnchor.constraint(equalTo: addImageButton.widthAnchor),
            selectNewPhotoButton.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
    
    // MARK: - Selectors
    @objc func addImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        parent?.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - SetupAccountSubview
extension SelectPhotoView: SetupAccountSubview {
    func canContinue() -> Bool {
        return selectedImage
    }
}

// MARK: - UIImagePicker Delegate
extension SelectPhotoView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            addImageButton.setImage(editedImage, for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            addImageButton.setImage(originalImage, for: .normal)
        }
        parent?.dismiss(animated: true, completion: nil)
        
        self.selectedImage = true
        self.selectNewPhotoButton.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent?.dismiss(animated: true, completion: nil)
    }
}

