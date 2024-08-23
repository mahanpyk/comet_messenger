package com.solana.comet_messenger

import cash.z.ecc.android.bip39.Mnemonics
import cash.z.ecc.android.bip39.Mnemonics.WordCount
import cash.z.ecc.android.bip39.toSeed
import com.solana.Config
import com.solana.SolanaHelper
import com.solana.actions.sendMessage
import com.solana.core.PublicKey
import com.solana.models.buffer.AccountInfo
import com.solana.models.buffer.MessageModel
import com.solana.models.buffer.MessageState
import com.solana.models.buffer.MessageStatus
import com.solana.models.buffer.SendMessageType
import com.solana.models.buffer.UserModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.sol4k.Base58
import org.sol4k.Keypair
import java.util.Locale
import java.util.UUID

class MainActivity : FlutterActivity() {
    private val CHANNEL = "comet_messenger/encryption"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "createCipher" -> {
                    val encryptedData = EncryptdecryptJavaHelper.generate32ByteKey()
                    result.success(encryptedData)
                }

                "importCipher" -> {
                    val tokenCipher: String = call.argument("tokenCipher") ?: ""
                    val base64PrivateKey: String = call.argument("base64PrivateKey") ?: ""
                    val decryptedData = RSAUtil.decrypt(tokenCipher, base64PrivateKey)
                    result.success(decryptedData)
                }

                "decryptMessage" -> {
                    val message: String = call.argument("message") ?: ""
                    val privateKey: String = call.argument("privateKey") ?: ""
                    val decryptedData = EncryptdecryptJavaHelper.decrypt(
                        EncryptdecryptJavaHelper.hexToBytes(message), privateKey
                    )
                    result.success(decryptedData)
                }

                "encryptMessage" -> {
                    val message: String = call.argument("message") ?: ""
                    val key: String = call.argument("key") ?: ""
                    val encryptedData = EncryptdecryptJavaHelper.encrypt(message, key)
                    result.success(encryptedData)
                }

                "keypairFromPhrase" -> {
                    val phrase: String = call.argument("phrase") ?: ""
                    val keypair = Keypair.fromSecretKey(
                        Mnemonics.MnemonicCode(
                            phrase,
                            Locale.ENGLISH.toString()
                        ).toSeed()
                    )
                    /// return public key and private key as String to Flutter
                    val publicKey = keypair.publicKey.toBase58()
                    val privateKey = Base58.encode(keypair.secret)
                    result.success("$publicKey*********$privateKey")
                }

                "sendTransaction" -> {
                    val message: String = call.argument("message") ?: ""
                    val privateKey: String = call.argument("privateKey") ?: ""
                    val basePublicKey: String = call.argument("basePublicKey") ?: ""
                    val conversationId: String = call.argument("conversationId") ?: ""
                    val userName: String = call.argument("userName") ?: ""
                    val publicKey: String = call.argument("publicKey") ?: ""
                    val time: String = call.argument("time") ?: ""

//                    Config.network = "Main"
                    Config.network = "dev"
                    val accountUser1 = SolanaHelper.createAccountWithString(privateKey)

//                    val id = createWithSeed(
//                        PublicKey(basePublicKey),
//                        userName,
//                        PublicKey("2qT2bqsFTdD1uDQ1mqLJsnbTumeJAeymUeDC43BSmP8H")
//                    ).toBase58()

                    val userPublicKey = PublicKey(publicKey).toBase58()
                    val conversationIdDecrypt = PublicKey(conversationId)

                    val model = MessageModel(
                        UUID.randomUUID().toString(),
                        message,
                        time,
                        ArrayList<UserModel>(),
                        userPublicKey,
                        MessageStatus.PENDING.name,
                        MessageState.SEND.name,
                        SendMessageType.text.toString(),
                        null,
                        null,
                        "",
                        ""
                    )
                    model.setOfflineAdded(false)
                    SolanaHelper.getSolana_dev().action.sendMessage(
                        conversationIdDecrypt,
                        accountUser1,
                        model,
                    ) { response ->
                        response.onSuccess { result.success(response.isSuccess.toString()) }
                            .onFailure { error ->
                                result.error(
                                    error.toString(),
                                    error.message,
                                    null
                                )
                            }
                    }
                }

                "createAccount" -> {
                    val avatar: String = call.argument("avatar") ?: ""
                    val username: String = call.argument("username") ?: ""

//                    Config.network = "Main"
                    Config.network = "dev"
                    val mnemonic =
                        Mnemonics.MnemonicCode(WordCount.COUNT_12, Locale.ENGLISH.language)
                    val keypair = Keypair.fromSecretKey(mnemonic.toSeed())
                    val publicKeyFromUserName: PublicKey =
                        SolanaHelper.createWithSeed(username)
                    val userPublicKey = PublicKey(keypair.publicKey.toBase58())

                    val result = object : SolanaHelper.OnResponse {
                        override fun onSuccess(accountInfo: AccountInfo?) {
                            // Implement the success logic here
                            val publicKey = keypair.publicKey.toBase58()
                            val privateKey = Base58.encode(keypair.secret)
                            result.success("$mnemonic*********$publicKey*********$privateKey*********$publicKeyFromUserName")
                            return
                        }

                        override fun onFailure(e: Exception?) {
                            // Implement the failure logic here
                            result.error(
                                e.toString(),
                                e?.message,
                                null
                            )
                            return
                        }
                    }

                    SolanaHelper.getOrCreateAccount(
                        userPublicKey,
                        publicKeyFromUserName,
                        username,
                        avatar,
                        avatar,
                        result,
                    )
                }

                else -> result.notImplemented()
            }
        }
    }
}
