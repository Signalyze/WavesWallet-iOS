//
//  AnyTransaction+Mapper.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 31/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

extension Node.DTO.Transaction {

    var anyTransaction: DomainLayer.DTO.AnyTransaction {

        switch self  {
        case .unrecognised(let transaction):
            return .unrecognised(.init(transaction: transaction))

        case .issue(let transaction):
            return .issue(.init(transaction: transaction))

        case .transfer(let transaction):
            return .transfer(.init(transaction: transaction))

        case .reissue(let transaction):
            return .reissue(.init(transaction: transaction))

        case .burn(let transaction):
            return .burn(.init(transaction: transaction))

        case .exchange(let transaction):
            return .exchange(.init(transaction: transaction))

        case .lease(let transaction):
            return .lease(.init(transaction: transaction))

        case .leaseCancel(let transaction):
            return .leaseCancel(.init(transaction: transaction))

        case .alias(let transaction):
            return .alias(.init(transaction: transaction))

        case .massTransfer(let transaction):
            return   .massTransfer(.init(transaction: transaction))

        case .data(let transaction):
            return .data(.init(transaction: transaction))
        }
    }
}

extension Node.DTO.TransactionContainers {

    func anyTransactions() -> [DomainLayer.DTO.AnyTransaction] {

        var anyTransactions = [DomainLayer.DTO.AnyTransaction]()

        for transaction in self.transactions {
           anyTransactions.append(transaction.anyTransaction)
        }

        return anyTransactions
    }
}

extension DomainLayer.DTO.AnyTransaction {

    var transaction: Transaction {
        
        switch self {
        case .unrecognised(let tx):
            return UnrecognisedTransaction(transaction: tx)

        case .issue(let tx):
            return IssueTransaction(transaction: tx)

        case .transfer(let tx):
            return TransferTransaction(transaction: tx)

        case .reissue(let tx):
            return ReissueTransaction(transaction: tx)

        case .burn(let tx):
            return BurnTransaction(transaction: tx)

        case .exchange(let tx):
            return ExchangeTransaction(transaction: tx)

        case .lease(let tx):
            return LeaseTransaction(transaction: tx)

        case .leaseCancel(let tx):
            return LeaseCancelTransaction(transaction: tx)

        case .alias(let tx):
            return AliasTransaction(transaction: tx)

        case .massTransfer(let tx):
            return MassTransferTransaction(transaction: tx)

        case .data(let tx):
            return DataTransaction(transaction: tx)
        }
    }

    func anyTransaction(from: Transaction) -> AnyTransaction {

        let any = AnyTransaction()
        any.type = from.type
        any.id = from.id
        any.sender = from.sender
        any.senderPublicKey = from.senderPublicKey
        any.fee = from.fee
        any.timestamp = from.timestamp
        any.height = from.height
        any.version = from.version
        any.modified = from.modified

        switch self {
        case .unrecognised:
            any.unrecognisedTransaction = from as? UnrecognisedTransaction

        case .issue:
            any.issueTransaction = from as? IssueTransaction

        case .transfer:
            any.transferTransaction = from as? TransferTransaction

        case .reissue:
            any.reissueTransaction = from as? ReissueTransaction

        case .burn:
            any.burnTransaction = from as? BurnTransaction

        case .exchange:
            any.exchangeTransaction = from as? ExchangeTransaction

        case .lease:
            any.leaseTransaction = from as? LeaseTransaction

        case .leaseCancel:
            any.leaseCancelTransaction = from as? LeaseCancelTransaction

        case .alias:
            any.aliasTransaction = from as? AliasTransaction

        case .massTransfer:
            any.massTransferTransaction = from as? MassTransferTransaction

        case .data:
            any.dataTransaction = from as? DataTransaction
        }

        return any
    }
}
