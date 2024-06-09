package com.solana.comet_messenger

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import io.flutter.plugin.common.MethodChannel
import android.util.Base64

class MainActivity : FlutterActivity() {
    /*private val CHANNEL = "com.example.decrypt"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(
            flutterEngine?.dartExecutor?.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "decrypt") {
                val res = call.argument<String>("res")
                val clazz = call.argument<String>("clazz")

                if (res != null && clazz != null) {
                    // Implement your decrypt method here
                    val decryptedData = decrypt(res, clazz)
                    result.success(decryptedData)
                } else {
                    result.error("INVALID_ARGUMENT", "Argument 'res' or 'clazz' is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Implement the decrypt method here
    fun <T> decrypt(
        res: String,
        clazz: Class<T>,
    ): T {
        try {
            val base64decodedBytes: ByteArray = Base64.decode(res)
            val data = ByteArray(4)
            System.arraycopy(base64decodedBytes, 0, data, 0, 4)
            val dataLengthModel = Borsh.deserialize(
                data,
                DataLengthModel::class.java
            )
            var length = dataLengthModel.length

            if (length == 0) {
                length = 288;
            }
            val accountDataBuffer = ByteArray(length)
            System.arraycopy(base64decodedBytes, 4, accountDataBuffer, 0, length)
            return Borsh.deserialize(accountDataBuffer, clazz)
        } catch (error: Exception) {
            print(error.message);
            return Borsh.deserialize(ByteArray(2), clazz);
        }

    }*/
}
