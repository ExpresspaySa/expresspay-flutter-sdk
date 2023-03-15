//
//  SaleEventHandler.swift
//  expresspay_sdk
//
//  Created by Zohaib Kambrani on 03/03/2023.
//

import Foundation
import Flutter
import UIKit
import ExpressPaySDK
import PassKit


class ApplePayEventHandler : NSObject, FlutterStreamHandler{
    
    var eventSink:FlutterEventSink? = nil
    
    private lazy var saleAdapter: ExpressPaySaleAdapter = {
        let adapter = ExpressPayAdapterFactory().createSale()
        adapter.delegate = self
        return adapter
    }()
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        if let params = arguments as? [String:Any],
           let order = params["ExpresspaySaleOrder"] as? [String : Any?],
           let payer =  params["ExpresspayPayer"] as? [String : Any?],
           let applePayMerchantId = params["applePayMerchantId"] as? String{
            
            let order = ExpressPaySaleOrder.from(dictionary: order)
            let payer = ExpressPayPayer.from(dictionary: payer)
            
            // The precise way to present by sdk it self
            ExpressApplePay()
                .set(order: order)
                .set(payer: payer)
                .set(applePayMerchantID: applePayMerchantId)
                .enable(logs: ENABLE_DEBUG)
                .on(authentication: { pk in
                    debugPrint(pk)
                    self.handleAuth(paymentToken: pk.token)
                    
                }).on(transactionFailure: { response in
                    debugPrint(response)
                    self.eventSink?(["failure":response])
                    
                }).on(transactionSuccess: { response in
                    debugPrint(response)
                    self.eventSink?(["success":response])
                    
                }).initialize(
                    target: UIApplication.currentViewController()!,
                    onError: { error in
                        self.eventSink?([
                            "error": [
                                "error" : error
                            ]
                        ])
                    },
                    onPresent: onPresent
                )
            
        }
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    private func onPresent(){
        debugPrint("onPresent :)")
        eventSink?(["onPresent" : ":)"])
    }
    
    private func handleAuth(paymentToken:PKPaymentToken){
        let data = [
            "authentication":[
                "transactionIdentifier":paymentToken.transactionIdentifier,
                "paymentData":paymentToken.paymentData,
                "paymentMethod":[
                    "displayName" : paymentToken.paymentMethod.displayName,
                    "network" : paymentToken.paymentMethod.network?.rawValue ?? "",
//                    "type" : paymentToken.paymentMethod.type?.rawValue,
                ]
            ]
        ]
        self.eventSink?(data)
    }
    
    private func handleSuccess(response: ExpressPayGetTransactionDetailsSuccess){
        debugPrint("native.transactionSuccess.data ==> \(response.toJSON(root: "success"))")
        eventSink?(response.toJSON(root: "success"))
    }
    
    private func handleFailure(error:Any){
        if let e = error as? ExpressPayError{
            eventSink?(["error" : e.json()])
        }else if let e = error as? Encodable{
            eventSink?(e.toJSON(root: "failure"))
        }else{
            let error = [
                "result" : "ERROR",
                "error_code" : 100000,
                "error_message" : "\(error)",
                "errors" : [],
            ] as [String : Any]
            eventSink?(["error":error])
        }
    }
    
}

extension ApplePayEventHandler : ExpressPayAdapterDelegate{
    
    func willSendRequest(_ request: ExpressPayDataRequest) {
        
    }
    
    func didReceiveResponse(_ reponse: ExpressPayDataResponse?) {
        
    }
    
}


