package com.solana.comet_messenger

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

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
                    val encryptedData = RSAUtil.decrypt(tokenCipher, base64PrivateKey)
                    result.success(encryptedData)
                }

                "decryptMessage" -> {
                    val massage: String = call.argument("massage") ?: ""
                    val privateKey: String = call.argument("privateKey") ?: ""
                    val encryptedData = EncryptdecryptJavaHelper.decrypt(
                        EncryptdecryptJavaHelper.hexToBytes(massage), privateKey
                    )
                    result.success(encryptedData)
                }

                else -> result.notImplemented()
            }
        }
    }
}
