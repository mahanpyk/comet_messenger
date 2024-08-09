package com.solana.customConfig;

import com.solana.Config;

public class CustomContactPda {

    public static String getContactPda(){
        if (Config.network.equals("Main")){
//            return "5YJKt9FKrjXJ5ezojvKeHkDQmwypPE8DQGgqfS6K7Tb6";//(new)
            return "D4VSz2XZviYv2fH4eR4W12Dv4b1XKRqM5XMaDPvKRALo";
        } else {
//            return "6t53MR4P43doyXv6t7r1N66GQVwWwRjxsbxRgvhEDdyz";//(new)
            return "J98ZB5pyfqah9xxue6HBYkj2xxsyga43vt3fG772iLoH";
        }
    }

}