package com.solana.comet_messenger;

import android.util.Log;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import android.os.Build;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import java.security.*;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Arrays;
import java.util.Base64;

 class EncryptdecryptJavaHelper {
    public static void callEncrypAndDecrypt() throws Exception {
        String walletPubkey = "621Y5HvVG8syzLZqRspJMbDrkZKxX3MdFs1pZMDRwojx";
        String walletPrivateKey =
                "2D7yVTFHwvsjLKuDyKMrtxr9Jv7z1JTjxnGyo2Uhr36UjG6JKWymZQSXXoXXBUvpZzyPjMqfTYtzZ9fZz9uiixc2";
        String text32bytes = generate32ByteKey();
        Log.i("", "");

        String encryptedWalletPubkey = encrypt(text32bytes,walletPubkey);
//        String encryptedWalletPubkey = encrypt(text32bytes, "1234567891234567");


        String decryptedWalletPubkey = decrypt(hexToBytes(encryptedWalletPubkey), walletPubkey);
//        String decryptedWalletPubkey = decrypt(hexToBytes(encryptedWalletPubkey), "1234567891234567");


    }

    public static String encrypt(String data, String KEY) throws Exception {
        String newkey = getUniqueHash(KEY);
        SecretKeySpec secretKey = new SecretKeySpec(newkey.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
//        return cipher.doFinal(data.getBytes());
        byte[] encryptedBytes = cipher.doFinal(data.getBytes());
        return bytesToHex(encryptedBytes);
    }

    public static String decrypt(byte[] encryptedData, String KEY) throws Exception {
        String newkey = getUniqueHash(KEY);
        SecretKeySpec secretKey = new SecretKeySpec(newkey.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedData = cipher.doFinal(encryptedData);
        String temp = new String(decryptedData);
//        System.out.print("slam");
        return new String(decryptedData);
    }

    public static String generate32ByteKey() {
        try {
            // Initialize a KeyGenerator with the desired algorithm and key size
            KeyGenerator keyGenerator = KeyGenerator.getInstance("AES");
            keyGenerator.init(256); // 256 bits = 32 bytes

            // Generate a secret key
            SecretKey secretKey = keyGenerator.generateKey();

            // Convert the SecretKey to a byte array
            byte[] keyBytes = secretKey.getEncoded();

            // Check if the keyBytes array is 32 bytes
            if (keyBytes.length == 32) {
                System.out.println("Generated 32-byte key: " + bytesToHex(keyBytes));
                return bytesToHex(keyBytes);
            } else {
                System.out.println("Key generation failed.");
            }
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Helper method to convert a byte array to a hex string
    public static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    public static byte[] hexToBytes(String hex) {
        int len = hex.length();
        byte[] bytes = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            bytes[i / 2] = (byte) ((Character.digit(hex.charAt(i), 16) << 4)
                    + Character.digit(hex.charAt(i + 1), 16));
        }
        return bytes;
    }

    public static String getUniqueHash(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(input.getBytes());

            // Take a portion of the hash and convert it to a hexadecimal string
            byte[] truncatedHash = Arrays.copyOf(hash, 8); // 8 bytes = 16 hexadecimal characters
            StringBuilder hexString = new StringBuilder(2 * truncatedHash.length);
            for (byte b : truncatedHash) {
                hexString.append(String.format("%02x", b));
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

}

 class RSAUtil {

    public static String publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCgFGVfrY4jQSoZQWWygZ83roKXWD4YeT2x2p41dGkPixe73rT2IW04glagN2vgoZoHuOPqa5and6kAmK2ujmCHu6D1auJhE2tXP+yLkpSiYMQucDKmCsWMnW9XlC5K7OSL77TXXcfvTvyZcjObEz6LIBRzs6+FqpFbUO9SJEfh6wIDAQAB";
    public static String privateKey = "MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKAUZV+tjiNBKhlBZbKBnzeugpdYPhh5PbHanjV0aQ+LF7vetPYhbTiCVqA3a+Chmge44+prlqd3qQCYra6OYIe7oPVq4mETa1c/7IuSlKJgxC5wMqYKxYydb1eULkrs5IvvtNddx+9O/JlyM5sTPosgFHOzr4WqkVtQ71IkR+HrAgMBAAECgYAkQLo8kteP0GAyXAcmCAkA2Tql" +
            "/8wASuTX9ITD4lsws/VqDKO64hMUKyBnJGX/91kkypCDNF5oCsdxZSJgV8owViYWZPnbvEcNqLtqgs7nj1UHuX9S5yYIPGN/mHL6OJJ7sosOd6rqdpg6JRRkAKUV+tmN/7Gh0+GFXM+ug6mgwQJBAO9/+CWpCAVoGxCA+YsTMb82fTOmGYMkZOAfQsvIV2v6DC8eJrSa+c0yCOTa3tirlCkhBfB08f8U2iEPS+Gu3bECQQCrG7O0gYmFL2RX1O+37ovyyHTbst4s4xbLW4jLzbSoimL235lCdIC+fllEEP96wPAiqo6dzmdH8KsGmVozsVRbAkB0ME8AZjp/9Pt8TDXD5LHzo8mlruUdnCBcIo5TMoRG2+3hRe1dHPonNCjgbdZCoyqjsWOiPfnQ2Brigvs7J4xhAkBGRiZUKC92x7QKbqXVgN9xYuq7oIanIM0nz/wq190uq0dh5Qtow7hshC/dSK3kmIEHe8z++tpoLWvQVgM538apAkBoSNfaTkDZhFavuiVl6L8cWCoDcJBItip8wKQhXwHp0O3HLg10OEd14M58ooNfpgt+8D8/8/2OOFaR0HzA+2Dm";

    public static PublicKey getPublicKey(String base64PublicKey) {
        PublicKey publicKey = null;
        try {
            X509EncodedKeySpec keySpec = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                keySpec = new X509EncodedKeySpec(Base64.getDecoder().decode(base64PublicKey.getBytes()));
            }
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            publicKey = keyFactory.generatePublic(keySpec);
            return publicKey;
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return publicKey;
    }

    public static PrivateKey getPrivateKey(String base64PrivateKey) {
        PrivateKey privateKey = null;
        PKCS8EncodedKeySpec keySpec = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            keySpec = new PKCS8EncodedKeySpec(Base64.getDecoder().decode(base64PrivateKey.getBytes()));
        }
        KeyFactory keyFactory = null;
        try {
            keyFactory = KeyFactory.getInstance("RSA");
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        try {
            privateKey = keyFactory.generatePrivate(keySpec);
        } catch (InvalidKeySpecException e) {
            e.printStackTrace();
        }
        return privateKey;
    }

    public static byte[] encrypt(String data, String publicKey) throws BadPaddingException, IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException {
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, getPublicKey(publicKey));
        return cipher.doFinal(data.getBytes());
    }

    public static String decrypt(byte[] data, PrivateKey privateKey) throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, BadPaddingException, IllegalBlockSizeException {
        Cipher cipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        return new String(cipher.doFinal(data));
    }


    public static String decrypt(String data, String base64PrivateKey) throws IllegalBlockSizeException, InvalidKeyException, BadPaddingException, NoSuchAlgorithmException, NoSuchPaddingException {

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return decrypt(Base64.getDecoder().decode(data.getBytes()), getPrivateKey(base64PrivateKey));
        }
        return "";
    }

    public static String encrypt(String arg) throws IllegalBlockSizeException, InvalidKeyException, NoSuchPaddingException, BadPaddingException {
        try {
            String encryptedString = null;
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
                encryptedString = Base64.getEncoder().encodeToString(encrypt(arg, publicKey));
            }
//            System.out.println(encryptedString);
//            String decryptedString = null;
//            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
//                decryptedString = RSAUtil.decrypt(encryptedString, privateKey);
//            }
//            System.out.println(decryptedString);
            return encryptedString;
        } catch (NoSuchAlgorithmException e) {
            System.err.println(e.getMessage());
        }

        return "";
    }
}