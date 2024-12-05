//
//  PersonalInfoController.swift
//  App1
//
//  Created by Gabriel Castillo on 6/13/24.
//

import UIKit

class PersonalInfoController: UIViewController {
    
    // MARK: - UI Components
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .palette.offWhite
        return view
    }()
    
    private lazy var updateImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .palette.offBlack.withAlphaComponent(0.5)
        button.layer.cornerRadius = 75
        button.clipsToBounds = true
        button.backgroundColor = .palette.offWhite
        button.layer.borderColor = UIColor.palette.offWhite.cgColor
        button.layer.borderWidth = 5
        button.addTarget(self, action: #selector(updateImageButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var updateImageText: UIButton = {
        let button = UIButton()
        button.setTitleColor(.palette.purple, for: .normal)
        button.setTitle("Select New Photo", for: .normal)
        button.titleLabel?.font = UIFont(name: "GaretW05-Bold", size: 16)
        button.addTarget(self, action: #selector(updateImageButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    let infoFieldView = 
    
    // MARK: - Data
    
    
    // MARK: - Life Cycle
    init(with image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.updateImageButton.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        Utils.customBackButton(for: self.navigationItem, target: self, action: #selector(backBtnTapped))
        setupNavBar()
        setupUI()
    }
    
    // MARK: - UI Setup
    private func setupNavBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)]
        self.navigationItem.title = "Personal Information"
    }
    
    
    private func setupUI() {
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(updateImageButton)
        updateImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(updateImageText)
        updateImageText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundView.heightAnchor.constraint(equalToConstant: 110),
            
            updateImageButton.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            updateImageButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            updateImageButton.heightAnchor.constraint(equalToConstant: 150),
            updateImageButton.widthAnchor.constraint(equalToConstant: 150),
            
            updateImageText.centerXAnchor.constraint(equalTo: updateImageButton.centerXAnchor),
            updateImageText.topAnchor.constraint(equalTo: updateImageButton.bottomAnchor, constant: 7),
        ])
    }
    
    // MARK: - Selectors
    @objc func backBtnTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func updateImageButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        parent?.present(imagePicker, animated: true, completion: {
            // TODO: update image in database
            print("Selected Image!")
        })
    }
}


// MARK: - UIImagePicker Delegate
extension PersonalInfoController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            updateImageButton.setImage(editedImage, for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            updateImageButton.setImage(originalImage, for: .normal)
        }
        parent?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent?.dismiss(animated: true, completion: nil)
    }
}

