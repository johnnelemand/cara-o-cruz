//
//  ResultViewController.swift
//  LanzamientoMoneda
//
//  Created by Johnne Lemand on 12/05/24.
//
import Combine
import UIKit
import ProjectUI

class ResultViewController: UIViewController {
    
    var numberOfCrosses: Int = 0
    var numberOfFaces: Int = 0
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let caraLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let cruzLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let winCrossLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = "¡Gano Cruz!"
        return label
    }()
    
    private let winHeadsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.text = "¡Gano Cara!"
        return label
    }()
    
    private let labelnumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        return stackView
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        return stackView
    }()
    
    private let playAgainButton: DSButton = {
        let button = DSButton(style: .secondary)
        button.setTitle(with: "Jugar de nuevo")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let historyButton: DSButton = {
        let button = DSButton(style: .secondary)
        button.setTitle(with: "Historial")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let winImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cup"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    init(numberOfCrosses: Int, numberOfFaces: Int) {
            self.numberOfCrosses = numberOfCrosses
            self.numberOfFaces = numberOfFaces
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        updateCaraLabel(withNumberOfFaces: numberOfFaces)
        updateCruzLabel(withNumberOfCrosses: numberOfCrosses)
        setupButtonActions()
    }
    
    private func setupBindings() {
        playAgainButton.didTap.sink { [weak self] _ in
                guard let self = self else { return }
                
                // Regresar a la vista anterior
            
                let playAgainViewController = PlayViewController()
                self.navigationController?.pushViewController(playAgainViewController, animated: true)
                
                // Llamar al método para reiniciar los contadores
                self.resetCounters()
            
              
            }.store(in: &cancellables)
    }
    
    private func setupButtonActions() {
        historyButton.addTarget(self, action: #selector(historyButtonTapped), for: .touchUpInside)
    }
    
    @objc private func historyButtonTapped() {
        // Ir a la pantalla de historial
        let HistoryViewController = HistoryViewController(numberOfCrosses: numberOfCrosses, numberOfFaces: numberOfFaces)
        navigationController?.pushViewController(HistoryViewController, animated: true)
    }
    
    private func resetCounters() {
        numberOfFaces = 0
        numberOfCrosses = 0
        // Actualizar las etiquetas de cara y cruz a cero
        updateCaraLabel(withNumberOfFaces: numberOfFaces)
        updateCruzLabel(withNumberOfCrosses: numberOfCrosses)
    }
    
    private func setupUI(){
        view.addSubview(labelnumberStackView)
        view.addSubview(winImage)
        view.addSubview(buttonStackView)
        setupInitialTexts()
        
        labelnumberStackView.addArrangedSubview(caraLabel)
        labelnumberStackView.addArrangedSubview(cruzLabel)
        
        buttonStackView.addArrangedSubview(playAgainButton)
        buttonStackView.addArrangedSubview(historyButton)
        
        labelnumberStackView
            .pin(.top, to: view.safeAreaLayoutGuide, constant: 40)
            .pin(.centerX, to: view.centerXAnchor)
        
        winImage
            .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, spacing: .xLarge)
            .pin(.centerX, to: view.centerXAnchor)
        
        buttonStackView
            .pin(.top, yAnchor: winImage.bottomAnchor, offset: 20)
            .pin(.centerX, to: view.centerXAnchor)
        
        if numberOfFaces == 3 && numberOfCrosses == 2 {
                
                view.addSubview(winHeadsLabel)
                winHeadsLabel
                    .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 315)
                    .pin(.centerX, to: view.centerXAnchor)
            } else if numberOfFaces == 2 && numberOfCrosses == 3 {
                view.addSubview(winCrossLabel)
                
                winCrossLabel
                    .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 315)
                    .pin(.centerX, to: view.centerXAnchor)
            } else if numberOfFaces == 0 && numberOfCrosses == 3 {
                
                view.addSubview(winCrossLabel)
                winCrossLabel
                    .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 315)
                    .pin(.centerX, to: view.centerXAnchor)
            } else if numberOfFaces == 3 && numberOfCrosses == 0 {
                view.addSubview(winHeadsLabel)
                
                winHeadsLabel
                    .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 315)
                    .pin(.centerX, to: view.centerXAnchor)
            } else {
                // Si no se cumplen ninguna de las condiciones, oculta ambas etiquetas ganadoras
                winCrossLabel.isHidden = true
                winHeadsLabel.isHidden = true
            }
        
        
    }
    
    func updateCaraLabel(withNumberOfFaces numberOfFaces: Int) {
        caraLabel.attributedText = attributedText(withTitle: "cara:", number: numberOfFaces, isBold: true)
    }
    
    func updateCruzLabel(withNumberOfCrosses numberOfCrosses: Int) {
        cruzLabel.attributedText = attributedText(withTitle: "cruz:", number: numberOfCrosses, isBold: true)
    }
    
    private func attributedText(withTitle title: String, number: Int, isBold: Bool) -> NSAttributedString {
            let attributedString = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)])
            let numberString = NSAttributedString(string: " \(number)", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
            attributedString.append(numberString)
            return attributedString
        }
    
    private func setupInitialTexts() {
            caraLabel.attributedText = attributedText(withTitle: "cara:", number: 0, isBold: true)
            cruzLabel.attributedText = attributedText(withTitle: "cruz:", number: 0, isBold: true)
        }
    

}
