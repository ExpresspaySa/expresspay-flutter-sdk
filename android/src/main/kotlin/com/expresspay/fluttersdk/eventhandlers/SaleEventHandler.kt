package com.expresspay.fluttersdk.eventhandlers

import android.util.Log
import com.expresspay.sdk.core.ExpresspaySdk
import com.expresspay.fluttersdk.helper.toMap
import com.expresspay.sdk.ExpressPayHomeActivity_
import com.expresspay.sdk.model.request.card.ExpresspayCard
import com.expresspay.sdk.model.request.options.ExpresspaySaleOptions
import com.expresspay.sdk.model.request.order.ExpresspaySaleOrder
import com.expresspay.sdk.model.request.payer.ExpresspayPayer
import com.expresspay.sdk.model.response.base.ExpresspayResponse
import com.expresspay.sdk.model.response.base.error.ExpresspayError
import com.expresspay.sdk.model.response.sale.*
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel
import kotlin.math.sin


class SaleEventHandler: EventChannel.StreamHandler {
    var sink:EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        sink = events

        (arguments as? Map<*, *>)?.let {
            print(
                with(it) {
                    (get("ExpresspaySaleOrder") as? Map<*, *>)?.let { orderMap ->
                        (get("ExpresspayPayer") as? Map<*, *>)?.let { payerMap ->
                            (get("ExpresspayCard") as? Map<*, *>)?.let { cardMap ->
                                (get("auth") as? Boolean)?.let { auth ->

                                    val order = Gson().fromJson(Gson().toJson(orderMap), ExpresspaySaleOrder::class.java)
                                    val payer = Gson().fromJson(Gson().toJson(payerMap), ExpresspayPayer::class.java)
                                    val card = Gson().fromJson(Gson().toJson(cardMap), ExpresspayCard::class.java)

                                    var options:ExpresspaySaleOptions? = null
                                    (get("ExpresspaySaleOption") as? Map<*, *>)?.let {
                                        options = Gson().fromJson(Gson().toJson(payerMap), ExpresspaySaleOptions::class.java)
                                    }

                                    sale(auth = auth, order = order, payer = payer, card = card, saleOptions = options)

                                    "All params are valid"
                                } ?: "Missing 'Boolean' auth parameter"
                            } ?: "Missing 'ExpresspayCard' parameter"
                        } ?: "Missing 'ExpresspayPayer' parameter"
                    } ?: "Missing 'ExpresspaySaleOrder' parameter"
                }
            )
        }

    }

    override fun onCancel(arguments: Any?) {
    }

    fun sale(auth:Boolean, order:ExpresspaySaleOrder, payer:ExpresspayPayer, card:ExpresspayCard, saleOptions:ExpresspaySaleOptions?){

        Log.i("EventChannel", "payer.email-1")
        Log.i("EventChannel", payer.email)
        Log.i("EventChannel", "payer.email-2")
        ExpresspaySdk.Adapter.SALE.execute(
            order = order,
            card = card,
            payer = payer,
            termUrl3ds = "https://pay.expresspay.sa/",
            options = saleOptions,
            auth = auth,
            callback = object : ExpresspaySaleCallback {
                override fun onResponse(response: ExpresspaySaleResponse) {
                    send(mapOf("responseJSON" to response.toMap()))
                    super.onResponse(response)
                }

                override fun onResult(result: ExpresspaySaleResult) {
                    val res = result.result
                    when (res) {
                        is ExpresspaySaleDecline -> send(mapOf("decline" to res.toMap()))
                        is ExpresspaySaleRecurring -> send(mapOf("recurring" to res.toMap()))
                        is ExpresspaySaleRedirect -> send(mapOf("redirect" to res.toMap()))
                        is ExpresspaySale3Ds -> send(mapOf("secure3d" to res.toMap()))
                        is ExpresspaySaleSuccess -> send(mapOf("success" to res.toMap()))
                    }
                }

                override fun onError(error: ExpresspayError){
                    send(mapOf("error" to error.toMap()))
                }

                override fun onFailure(throwable: Throwable) {
                    send(mapOf("failure" to throwable.toMap()))
                    super.onFailure(throwable)
                }
            }
        )

    }
    private fun send(map:Map<*,*>){
        sink?.success(map)
    }
}