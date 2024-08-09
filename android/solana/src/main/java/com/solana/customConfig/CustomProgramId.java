package com.solana.customConfig;

import com.solana.Config;

public class CustomProgramId {

    public static String getContactProgramId(){
        if (Config.network.equals("Main")){
//            return "7Rt2exuf4pE4jZjvH8KHSpJjxFCxFWUsRWaUuUs9s83e";//(new)
            return "CUdVSkaXMoAnr7NLSKjD25Zk5gpTrhtuXJ4Fxaw7nxRA";
        } else {
//            return "38Xxqe3uSBSRPp771ja4tLFCQKn6CeNhh7YbuQhQd5E2";//(new)
            return "2qwWoMoPvxKfypbujTNwqWqmuriMkXMPZV21YCvd8BdU";
        }
    }

    public static String getProfileProgramId(){
        if (Config.network.equals("Main")){
            return "5nFHkukP8jGuQEzpMH1H6hk5i6HUt6KamZw2NuSr97Ru";
        } else {
            return "HwE7A7DcLcscNfJBf3kZt9TABvfRWuD8RcT4kVhYPM4M";
        }
    }

    public static String getConversationProgramId(){
        if (Config.network.equals("Main")){
            return "9ANy7cbrSBGFMMjHURsnpKSiqm9rdPFGZokzS62FvLFU";
        } else {
            return "7jRAvySXHGTJMKBQNfNxmemLnW1gnCPm8Bv1WWwzUN5Y";
        }
    }
}