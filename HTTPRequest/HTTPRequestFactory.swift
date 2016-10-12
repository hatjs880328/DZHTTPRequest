//
//  HTTPRequestFactory.swift
//  FSZCItem
//
//  Created by MrShan on 16/6/23.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import Foundation

//MARK:基本返回类
/// 返回数据类（基类）
public class ResponseClass {
    
    /// 需要处理的数据
    public var responseData:AnyObject!
    
    /// 是否展示提示信息
    var ifshowalertinfo:HTTPERRORInfoShow!
    
    /// 当前数据的数据类型
    var datatype:ResponseType!
    
    /// 错误处理的方法参数
    var errorAction :(errorType:ERRORMsgType)->Void!
    
    func setData(data:AnyObject) {
        self.responseData = data as! String
        self.datatype = ResponseType.STRING
    }
    
    init(data:AnyObject,alertinfoshouldshow:HTTPERRORInfoShow,errorAction:(errorType:ERRORMsgType)->Void) {
        self.ifshowalertinfo = alertinfoshouldshow
        self.errorAction = errorAction
        self.setData(data)
    }
}

/// 返回数据类-字典
public class ResponseDataDictionary:ResponseClass {
    
    override init(data: AnyObject, alertinfoshouldshow: HTTPERRORInfoShow,errorAction:(errorType:ERRORMsgType)->Void) {
        super.init(data: data, alertinfoshouldshow: alertinfoshouldshow,errorAction:errorAction)
    }
    
    /**
     返回的数据类型为字典
     
     - parameter data: dic数据
     */
    override func setData(data: AnyObject) {
        let dicResponseData = data as! NSDictionary
        if(dicResponseData["state"] as! String == "1"){
            let responseSecondLeveldata = dicResponseData["data"]
            switch responseSecondLeveldata!.self {
            case is NSDictionary : self.responseData = responseSecondLeveldata as! NSDictionary;self.datatype = ResponseType.DIC
            case is NSArray: self.responseData = responseSecondLeveldata as! NSArray;self.datatype = ResponseType.ARRAY
            case is String: self.responseData = responseSecondLeveldata as! String;self.datatype = ResponseType.STRING
            default:break
            }
        }else{
            if dicResponseData["errcode"] as! String != "999" {
                //返回错误数据 ERRMSG 字典中的KEY
                NETWORKErrorProgress().errorMsgProgress(ERRORMsgType.progressError, ifcanshow: self.ifshowalertinfo, errormsg: dicResponseData["errmsg"] as! String, errorAction: { (errorType) -> Void in
                    self.errorAction(errorType: errorType)
                })
            }else{
                NETWORKErrorProgress().moreThanoneUserLoginwithsameoneAPPID()
            }
        }
    }
}

/// 返回数据类-数组
public class ResponseDataNSArray:ResponseClass {
    
    override init(data: AnyObject, alertinfoshouldshow: HTTPERRORInfoShow,errorAction:(errorType:ERRORMsgType)->Void) {
        super.init(data: data, alertinfoshouldshow: alertinfoshouldshow,errorAction:errorAction)
    }
    
    /**
     返回的数据类型为数组
     
     - parameter data: 数组数据
     */
    override func setData(data: AnyObject) {
        self.responseData = data as! NSArray
    }
}

/// 数据处理工厂类
public class ResponseFactoary: NSObject {
    func responseInstance(instancename:ResponseType,data:AnyObject,alertinfoshouldshow:HTTPERRORInfoShow,errorAction:(errorType:ERRORMsgType)->Void)->ResponseClass {
        if instancename == ResponseType.DIC {
            return ResponseDataDictionary(data: data,alertinfoshouldshow:alertinfoshouldshow,errorAction:errorAction)
        }else if instancename == ResponseType.ARRAY {
            return ResponseDataNSArray(data: data,alertinfoshouldshow:alertinfoshouldshow,errorAction:errorAction)
        }else{
            return ResponseClass(data: data,alertinfoshouldshow:alertinfoshouldshow,errorAction:errorAction)
        }
    }
}