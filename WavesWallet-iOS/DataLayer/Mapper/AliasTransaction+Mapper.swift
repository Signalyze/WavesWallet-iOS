//
//  AliasTransaction+Mapper.swift
//  WavesWallet-iOS
//
//  Created by mefilt on 30.08.2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

extension AliasTransaction {

    convenience init(transaction: DomainLayer.DTO.AliasTransaction) {
        self.init()
        type = transaction.type
        id = transaction.id
        sender = transaction.sender
        senderPublicKey = transaction.sender
        fee = transaction.fee
        timestamp = transaction.timestamp
        version = transaction.version
        height = transaction.height ?? -1
        modified = transaction.modified

        signature = transaction.signature
        alias = transaction.alias
        status = transaction.status.rawValue
    }
}

extension DomainLayer.DTO.AliasTransaction {

    init(transaction: Node.DTO.AliasTransaction, status: DomainLayer.DTO.TransactionStatus) {

        type = transaction.type
        id = transaction.id
        sender = transaction.sender
        senderPublicKey = transaction.sender
        fee = transaction.fee
        timestamp = transaction.timestamp
        version = transaction.version
        height = transaction.height
        modified = Date()

        signature = transaction.signature
        alias = transaction.alias
        proofs = transaction.proofs
        self.status = status
    }

    init(transaction: AliasTransaction) {
        type = transaction.type
        id = transaction.id
        sender = transaction.sender
        senderPublicKey = transaction.sender
        fee = transaction.fee
        timestamp = transaction.timestamp
        version = transaction.version
        height = transaction.height
        modified = transaction.modified

        signature = transaction.signature
        alias = transaction.alias
        proofs = []
        status = DomainLayer.DTO.TransactionStatus(rawValue: transaction.status) ?? .completed
    }
}
