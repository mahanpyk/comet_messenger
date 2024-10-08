package com.solana.customConfig;

import com.solana.Config;

public class CustomContactPda {

    public static String[] getContactPda(){
        String[] a = new String[10];
        if (Config.network.equals("Main")){
            a[0] = "Ba8AcvH4G6DA1QKJLePQExfh4VzGLffPojGzeW9N6t8u";
            a[1] = "";
            a[2] = "";
            a[3] = "";
            a[4] = "";
            a[5] = "";
            a[6] = "";
            a[7] = "";
            a[8] = "";
            a[9] = "";
        } else {
            a[0] = "FdUUNThNuYykGoETF22HF451AKpfMvKQF1cYCiexzA9X";
            a[1] = "DDvjMTHkcPKH4R2uf7FrAmdPEDBHTvynKowmfKdBVGuq";
            a[2] = "9XoLHHtZJXYhC9YFBotaPjTTsi2V5X4KXMej7Db4zzX";
            a[3] = "FQ4W4FATS2GfM52YsjrmeGtyAcSTnhPXwVoHeCUNmsWV";
            a[4] = "8eHAWLEnGLMKoTQxnsPcryTd8k8V3juNBpcdmM6WBeLn";
            a[5] = "AgBLVPjUNf6ggFKn2nrRTjUKMtMpctcPjuVVvVUQn5tj";
            a[6] = "8qw88zz2hZE7iptKxpxmk6L1ZG85wy9Q2UXvgW4r7kjb";
            a[7] = "9aUKc9WxbFCmALnrgy9fB5H45FDGydg2Xgymvg1ex28c";
            a[8] = "xQLUd1XJjP9RwJnxkkNzCbfHmpTEYeUEEQGA4ARqiDs";
            a[9] = "7WFmPNLNwZQFTgyhHiqgvo9DmGGdm5L4nUYNngTcWt1f";
        }
        return a;
    }

    public static String getContactPda_old(){
        if (Config.network.equals("Main")){
            return "D4VSz2XZviYv2fH4eR4W12Dv4b1XKRqM5XMaDPvKRALo";
        } else {
            return "J98ZB5pyfqah9xxue6HBYkj2xxsyga43vt3fG772iLoH";
        }
    }

}