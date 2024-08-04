package com.solana.comet_messenger

import cash.z.ecc.android.bip39.Mnemonics
import cash.z.ecc.android.bip39.toSeed
import com.solana.SolanaHelper.createAccountWithString1
import com.solana.SolanaHelper.getSolana
import com.solana.actions.sendMessage
import com.solana.core.PublicKey
import com.solana.models.buffer.MessageModel
import com.solana.models.buffer.MessageState
import com.solana.models.buffer.MessageStatus
import com.solana.models.buffer.SendMessageType
import com.solana.models.buffer.UserModel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
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
                    val publicKey = keypair.publicKey
                    val privateKey = keypair.secret
                    result.success("$publicKey*********$privateKey")
                }

                "sendTransaction" -> {
                    val message: String = call.argument("message") ?: ""
                    val privateKey: String = call.argument("privateKey") ?: ""
                    val publicKey: String = call.argument("publicKey") ?: ""
                    val accountUser1 = createAccountWithString1(privateKey)
                    val model = MessageModel(
                        UUID.randomUUID().toString(), message, "", ArrayList<UserModel>(),
                        PublicKey(publicKey).toBase58(),
                        MessageStatus.PENDING.name,
                        MessageState.SEND.name,
                        SendMessageType.text.toString(),
                        null,
                        null,
                        "",
                        ""
                    )

                    getSolana().action.sendMessage(
                        PublicKey(publicKey),
                        accountUser1,
                        model,
                    ) { response ->
                        response.onSuccess { result.success(response.isSuccess) }
                            .onFailure { error ->
                                result.error(
                                    error.toString(),
                                    error.message,
                                    null
                                )
                            }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
