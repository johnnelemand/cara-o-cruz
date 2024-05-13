//
//  PlayViewModel.swift
//  LanzamientoMoneda
//
//  Created by Johnne Lemand on 12/05/24.
//
import Combine
import Foundation

protocol AdditionalInfoProtocol{
    typealias ResultValidation = Result<Bool, Error>
    var sendActionsPublisher: PassthroughSubject<ResultValidation, Error> {get}
}

final class PlayViewModel: AdditionalInfoProtocol{
    var sendActionsPublisher = PassthroughSubject<ResultValidation, Error> ()
    
    func playGame() {
        var numberOfFaces = 0
        var numberOfCrosses = 0
        
        for _ in 0..<5 {
            let randomNumber = Int.random(in: 0...1)
            if randomNumber == 0 {
                numberOfFaces += 1
            } else {
                numberOfCrosses += 1
            }
        }
        
        if (numberOfFaces == 2 && numberOfCrosses == 3) || (numberOfFaces == 3 && numberOfCrosses == 2) || (numberOfFaces == 3 && numberOfCrosses == 3) {
            sendActionsPublisher.send(.success(true))
        } else {
            sendActionsPublisher.send(.failure(NSError(domain: "PlayViewModel", code: -190, userInfo: [NSLocalizedDescriptionKey: "No se cumplen las condiciones"])))
        }
    }
}
