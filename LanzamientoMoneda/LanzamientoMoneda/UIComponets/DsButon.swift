//
//  DsButon.swift
//  LanzamientoMoneda
//
//  Created by Johnne Lemand on 12/05/24.
//

import Combine
import ProjectUI
import UIKit

final class DSButton: UIButton {
    enum ButtonStyle {
        case primary
        case secondary
    }
    
    init(style: ButtonStyle) {
        super.init(frame: .zero)
        configureButton(with: style)
    }
    
    var didTap: AnyPublisher<Void, Never> {
        return self.publisher(for: .touchUpInside)
            .map { _ in () }
            .eraseToAnyPublisher()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton(with style: ButtonStyle) {
        switch style {
        case .primary:
            configurePrimaryButton()
        case .secondary:
            configureSecondaryButton()
        }
    }
    
    private func configurePrimaryButton() {
        backgroundColor = DesignSystem.primary
        titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
    }
    
    private func configureSecondaryButton() {
        backgroundColor = .clear
        setTitleColor(DesignSystem.primary, for: .normal)
    }
    
    public func setTitle(with title: String) {
        let yourAttributes: [NSAttributedString.Key: Any] = [
             .font: UIFont.systemFont(ofSize: 18),
             .foregroundColor: DesignSystem.primary ?? .blue,
             .underlineStyle: NSUnderlineStyle.single.rawValue
         ]
        
        let attributeString = NSMutableAttributedString(
            string: title,
            attributes: yourAttributes
        )
        setAttributedTitle(attributeString, for: .normal)
    }
}

