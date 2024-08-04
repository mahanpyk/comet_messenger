package com.solana.customConfig;

import com.solana.Config;

public class CustomContactPda {

    public static String getContactPda(){
        if (Config.network.equals("Main")){
            return "D4VSz2XZviYv2fH4eR4W12Dv4b1XKRqM5XMaDPvKRALo";
        } else {
            return "J98ZB5pyfqah9xxue6HBYkj2xxsyga43vt3fG772iLoH";
        }
    }

}