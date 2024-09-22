package com.solana.actions

import com.solana.core.Account
import com.solana.core.PublicKey
import com.solana.core.Transaction
import com.solana.models.REQUIRED_ACCOUNT_SPACE
import com.solana.programs.SystemProgram
import com.solana.programs.TokenProgram
import com.solana.api.getMinimumBalanceForRentExemption

fun Action.createTokenAccount(
    pk: PublicKey,
    mintAddress: PublicKey,
    onComplete: ((Result<Pair<String, PublicKey>>) -> Unit)
) {
    api.getMinimumBalanceForRentExemption(1000) {
        it.onSuccess { balance ->
            val transaction = Transaction()
            val newAccount = Account()
            val createAccountInstruction = SystemProgram.createAccount(
                fromPublicKey = pk,
                newAccountPublickey = newAccount.publicKey,
                lamports = balance,
                REQUIRED_ACCOUNT_SPACE,
                TokenProgram.PROGRAM_ID
            )
            transaction.addInstruction(createAccountInstruction)
            val initializeAccountInstruction = TokenProgram.initializeAccount(
                account = newAccount.publicKey,
                mint = mintAddress,
                owner = pk
            )
            transaction.addInstruction(initializeAccountInstruction)
            this.serializeAndSendWithFee(transaction, listOf(newAccount), null) { result ->
                result.onSuccess { transactionId ->
                    onComplete(Result.success(Pair(transactionId, newAccount.publicKey)))
                }.onFailure { error ->
                    onComplete(Result.failure(error))
                }
            }
        }.onFailure {
            onComplete(Result.failure(it))
        }
    }
}