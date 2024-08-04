package com.solana.api

import com.solana.models.buffer.BufferInfo
import com.solana.vendor.ResultError

fun Api.getTime(onComplete: ((String) -> Unit)) {
    val params: MutableList<Any> = ArrayList()
    router.request("getTime", params, onComplete)
}