//
//  QLRequest.swift
//  QTimelyLoan
//
//  Created by Sulei Qin on 16/9/26.
//  Copyright © 2016年 Jingnan Zhang. All rights reserved.
//

import UIKit
import Alamofire

//公共请求参数：
let APPKEY = "" // 系统分配的应用程序标识
let SIGN = "" // 签名
let TIMESTAMP = "" // 时间戳
let VERSION = "" // API版本
let USERID = "" // 当前操作用户(账号字符)
let ACCESSTOKEN = "" // Token
let DEVICEVERSION = "" //设备版本
let IMEI = "" //手机唯一标示

//公共响应参数：
let BODY = "" // 业务实体内容
let RESPONSESTATUS = "" // 响应状态
let ELAPSETIME = "" // 消耗时间
let ERRORCODE = "" // 错误代码
let ERRORMESSAGE = "" // 错误消息

//MARK:-
//闭包定义：类似于OC中的typedef
typealias resSuccessClosure = (_ bodyObject:AnyObject)->Void
typealias resFailClosure = (_ error:NSError)->Void

//MARK:-

class BaseRequest: NSObject,UIAlertViewDelegate {
    var upLoadURL = ""
    let url = NSURL(string: "")
    // POST 方式：
    func loadPOSTRequestWith(operationPath:String, params:[String: AnyObject]?,successAction:@escaping resSuccessClosure,failAction:@escaping resFailClosure) -> Void {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //        Alamofire.request(url, method: HTTPMethod.post, parameters: [:], encoding: JSONEncoding, headers: nil)

        var manger:SessionManager? = nil
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        //设置超时时间为15S
        config.timeoutIntervalForRequest = 30
        //根据config创建manager
        manger = SessionManager(configuration: config)
        
        manger?.request("", method: .post, parameters: params, encoding: JSONEncoding.default).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
               
                return .success
                
            }
            .responseJSON { response in
                //                debugPrint(response)
        }
        
        
        
        
    }

    // GET 方式：
    func loadGETRequestWith(operationPath:String, params:[String: AnyObject]?,successAction:@escaping resSuccessClosure,failAction:@escaping resFailClosure) -> Void {
        

        Alamofire.request("", method: .get, parameters: params, encoding: JSONEncoding.default).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            
                print("Progress: \(progress.fractionCompleted)")
            
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                
                return .success
                
            }
            .responseJSON { response in
                //                debugPrint(response)
        }
        
    }
}
