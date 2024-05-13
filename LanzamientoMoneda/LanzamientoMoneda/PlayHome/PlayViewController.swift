//
//  ViewController.swift
//  LanzamientoMoneda
//
//  Created by Johnne Lemand on 10/05/24.
//

import UIKit
import Combine

class PlayViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    private let viewModel = PlayViewModel()
    
    private var numberOfFaces = 0 {
            didSet {
                updateCaraLabel(withNumberOfFaces: numberOfFaces)
            }
        }
        
    private var numberOfCrosses = 0 {
            didSet {
                updateCruzLabel(withNumberOfCrosses: numberOfCrosses)
            }
        }
    
    var ModelView: AdditionalInfoProtocol?
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cara o Cruz"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let subLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Lanza una moneda virtual al aire."
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
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
    
    private let labelnumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        return stackView
    }()
    
    private let playButton: DSButton = {
        let button = DSButton(style: .primary)
        button.setTitle("Lanza la moneda!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gameButton: DSButton = {
        let button = DSButton(style: .secondary)
        button.setTitle("Lanza la moneda!", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let caraImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cara"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let cruzImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "cruz"))
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let playAgainButton: DSButton = {
        let button = DSButton(style: .secondary)
        button.setTitle(with: "Jugar de nuevo")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 15
        return stackView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupBindings()
    }
    
    private func setupBindings() {
        playButton.didTap.sink { [weak self] _ in
                   guard let self = self else { return }
                   self.playGame()
               }.store(in: &cancellables)
        
        playAgainButton.didTap.sink { [weak self] _ in
                guard let self = self else { return }
                // Llamar al método para jugar de nuevo
                self.playGame()
                // Llamar al método para reiniciar los contadores
                self.resetCounters()
            }.store(in: &cancellables)
    }
    
    private func resetCounters() {
        numberOfFaces = 0
        numberOfCrosses = 0
        // Actualizar las etiquetas de cara y cruz a cero
        updateCaraLabel(withNumberOfFaces: numberOfFaces)
        updateCruzLabel(withNumberOfCrosses: numberOfCrosses)
    }
    
    private func setupUI(){
        view.addSubview(titleLabel)
        view.addSubview(subLabel)
        view.addSubview(labelnumberStackView)
        view.addSubview(buttonsStackView)
        view.addSubview(caraImage)
        setupInitialTexts()
        
        labelnumberStackView.addArrangedSubview(caraLabel)
        labelnumberStackView.addArrangedSubview(cruzLabel)
        
        buttonsStackView.addArrangedSubview(playButton)
        buttonsStackView.addArrangedSubview(playAgainButton)
        
        
        titleLabel
            .pin(.top, to: view.safeAreaLayoutGuide, constant: 20)
            .pin(.centerX, to: view.centerXAnchor)
        
        subLabel
            .pin(.top, yAnchor: titleLabel.bottomAnchor, spacing: .medium)
            .pin(.centerX, to: view.centerXAnchor)
        
        labelnumberStackView
            .pin(.top, yAnchor: subLabel.bottomAnchor, offset: 50)
            .pin(.centerX, to: view.centerXAnchor)
        
        buttonsStackView
            .pin(.top, yAnchor: caraImage.bottomAnchor, offset: 20)
            .pin(.centerX, to: view.centerXAnchor)
        
        caraImage
            .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 20)
            .pin(.centerX, to: view.centerXAnchor)
        
        playButton
            .pinSize(to: CGSize(width: 200, height: 45))
        
    }
    
    private func playGame() {
            doAnimationCoin(image: caraImage)
            doAnimationCoin(image: cruzImage)
            
            let randomNumber = Int.random(in: 0...1)
            
            if randomNumber == 0 {
                numberOfFaces += 1
                showFace()
            } else {
                numberOfCrosses += 1
                showCross()
            }
            
            updateCaraLabel(withNumberOfFaces: numberOfFaces)
            updateCruzLabel(withNumberOfCrosses: numberOfCrosses)
            
        if numberOfFaces == 3 && numberOfCrosses == 2 {
                navigateToResultViewController()
            } else if numberOfFaces == 2 && numberOfCrosses == 3 {
                navigateToResultViewController()
            } else if numberOfFaces == 0 && numberOfCrosses == 3 {
                navigateToResultViewController()
            } else if numberOfFaces == 3 && numberOfCrosses == 0 {
                navigateToResultViewController()
            }
        }
        
    
    private func navigateToResultViewController() {
        let resultViewController = ResultViewController(numberOfCrosses: numberOfCrosses, numberOfFaces: numberOfFaces)
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    
    func doAnimationCoin(image: UIImageView) {
        let coinFlip = CABasicAnimation(keyPath: "transform.rotation.x")
            coinFlip.fromValue = 0
            coinFlip.toValue = Float.pi
            coinFlip.duration = 0.25
            coinFlip.repeatCount = 3
            coinFlip.autoreverses = true
            image.layer.add(coinFlip, forKey: "transform.rotation.x")
    }

    func showFace() {
            view.addSubview(caraImage)
            caraImage
                .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 20)
                .pin(.centerX, to: view.centerXAnchor)
        }
        
    func showCross() {
            view.addSubview(cruzImage)
            cruzImage
                .pin(.top, yAnchor: labelnumberStackView.bottomAnchor, offset: 20)
                .pin(.centerX, to: view.centerXAnchor)
        }

    func updateCaraLabel(withNumberOfFaces numberOfFaces: Int) {
        caraLabel.attributedText = attributedText(withTitle: "cara:", number: numberOfFaces, isBold: true)
        caraLabel.text = "Cara: \(numberOfFaces)"
    }
    
    func updateCruzLabel(withNumberOfCrosses numberOfCrosses: Int) {
        cruzLabel.attributedText = attributedText(withTitle: "cruz:", number: numberOfCrosses, isBold: true)
        cruzLabel.text = "Cruz: \(numberOfCrosses)"
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

