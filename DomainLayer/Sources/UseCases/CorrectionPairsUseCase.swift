//
//  CorrectionPairsUseCase.swift
//  DomainLayer
//
//  Created by rprokofev on 12.08.2019.
//  Copyright © 2019 Waves Platform. All rights reserved.
//

import Foundation
import RxSwift
import WavesSDKCrypto

public protocol CorrectionPairsUseCaseLogicProtocol {
    static func mapCorrectPairs(settingsIdsPairs: [String], pairs: [DomainLayer.DTO.CorrectionPairs.Pair]) -> [DomainLayer.DTO.CorrectionPairs.Pair]
}

public final class CorrectionPairsUseCaseLogic: CorrectionPairsUseCaseLogicProtocol {
    
    public static func mapCorrectPairs(settingsIdsPairs: [String], pairs: [DomainLayer.DTO.CorrectionPairs.Pair]) -> [DomainLayer.DTO.CorrectionPairs.Pair] {
        
        let result = pairs.map({ (pair) -> DomainLayer.DTO.CorrectionPairs.Pair in
            
            let amounIndex = settingsIdsPairs.firstIndex(of: pair.amountAsset)
            let priceIndex = settingsIdsPairs.firstIndex(of: pair.priceAsset)
            
            var amount: String! = nil
            var price: String! = nil
            
            if let amounIndex = amounIndex, let priceIndex = priceIndex {
                if amounIndex > priceIndex {
                    amount = pair.amountAsset
                    price = pair.priceAsset
                } else {
                    amount = pair.priceAsset
                    price = pair.amountAsset
                }
            } else if amounIndex != nil && priceIndex == nil {
                amount = pair.priceAsset
                price = pair.amountAsset
            } else if priceIndex != nil && amounIndex == nil {
                amount = pair.amountAsset
                price = pair.priceAsset
            } else {
                let amountBytes = WavesCrypto.shared.base58decode(input: pair.amountAsset).data?.hexDescription ?? ""
                let priceBytes = WavesCrypto.shared.base58decode(input: pair.priceAsset).data?.hexDescription ?? ""
                
                if amountBytes > priceBytes {
                    
                    amount = pair.amountAsset
                    price = pair.priceAsset
                    
                } else {
                    amount = pair.priceAsset
                    price = pair.amountAsset
                }
            }
            
            return DomainLayer.DTO.CorrectionPairs.Pair.init(amountAsset: amount,
                                                             priceAsset: price)
        })
        
        return result
    }
}

//TODO: Testing!
final class CorrectionPairsUseCase: CorrectionPairsUseCaseProtocol {
    
    private let repositories: RepositoriesFactoryProtocol
    private let useCases: UseCasesFactoryProtocol
    
    init(repositories: RepositoriesFactoryProtocol, useCases: UseCasesFactoryProtocol) {
        self.repositories = repositories
        self.useCases = useCases
    }
    
    func correction(pairs: [DomainLayer.DTO.CorrectionPairs.Pair]) -> Observable<[DomainLayer.DTO.CorrectionPairs.Pair]> {
        
        let pairs = repositories
            .matcherRepository
            .settingsIdsPairs()
            .flatMap { (pricePairs) -> Observable<[DomainLayer.DTO.CorrectionPairs.Pair]> in
                
                let result = CorrectionPairsUseCaseLogic.mapCorrectPairs(settingsIdsPairs: pricePairs, pairs: pairs)
                return Observable.just(result)
            }
        
        return pairs
    }
}

fileprivate extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
