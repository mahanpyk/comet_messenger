package com.solana.customConfig;

import com.solana.Config;

public class CustomContactPda {

    public static String getContactPda(){
        if (Config.network.equals("Main")){
            return "Ba8AcvH4G6DA1QKJLePQExfh4VzGLffPojGzeW9N6t8u";//(new)
//            return "D4VSz2XZviYv2fH4eR4W12Dv4b1XKRqM5XMaDPvKRALo";
        } else {
//            return "E5eMUoaFrJcPCGfBqythzCnMV99xjc8bR28M6mvgKRvx";//(new)
            return "J98ZB5pyfqah9xxue6HBYkj2xxsyga43vt3fG772iLoH";
        }
    }

    public static String testPda(){
        return "FdUUNThNuYykGoETF22HF451AKpfMvKQF1cYCiexzA9X";
    }

}