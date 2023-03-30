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


class CaptureEventHandler : NSObject, FlutterStreamHandler{
    var eventSink:FlutterEventSink? = nil
    
    private lazy var adapter: ExpressPayCaptureAdapter = {
        let adapter = ExpressPayAdapterFactory().createCapture()
        adapter.delegate = self
        return adapter
    }()
    
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        
        if let params = arguments as? [String:Any],
           let transactionId = params["transactionId"] as? String,
           let payerEmail = params["payerEmail"] as? String,
           let cardNumber = params["cardNumber"] as? String{
            let amount = params["amount"] as? Double
            
            adapter.delegate = self
            adapter.execute(
                transactionId: transactionId,
                payerEmail: payerEmail,
                cardNumber: cardNumber,
                amount: amount,
                callback: handleResponse
            )
            
        }
        
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    private func handleResponse(response: ExpressPayResponse<ExpressPayCaptureResult>){
        
        switch response {
        case .result(let result):
            
            switch result {
            case .success(let result):
                let json = result.toJSON(root: "success")
                eventSink?(json)
                
            case .decline(let result):
                let json = result.toJSON(root: "decline")
                eventSink?(json)

            default: break
                let json = ["failure" : ["error" : "Unhandled response case at ExpressPaySaleResult.result"]]
                eventSink?(json)
                
            }
                        
        case .error(let error):
            let json = ["error" : error.json()]
            eventSink?(json)
            print(error)
            
        case .failure(let exception):
            if let err = exception as? NSError{
                let json = ["failure" : err.userInfo]
                eventSink?(json)
            }else{
                let json = ["failure" : ["exception" : exception.localizedDescription]]
                eventSink?(json)
            }
            print(exception)
            
        default:
            let json = ["failure" : ["error" : "Unhandled response case at ExpressPayCaptureResult.result"]]
            eventSink?(json)
        }
    }

}


extension CaptureEventHandler : ExpressPayAdapterDelegate{
    
    func willSendRequest(_ request: ExpressPayDataRequest) {
        
    }
    
    func didReceiveResponse(_ reponse: ExpressPayDataResponse?) {
        if let data = reponse?.data,
           let dict = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed){
            eventSink?(["responseJSON" : dict])
        }
    }
    
}
