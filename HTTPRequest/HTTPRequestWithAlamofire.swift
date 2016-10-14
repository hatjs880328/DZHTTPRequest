//
//  AlamofireDatatool.swift
//  DataPresistenceLayer
//  is 1.0.3
//  Created by MrShan on 16/6/13.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import Foundation
import Alamofire
import RealReachability

/// 每个实例化网络请求的成功执行闭包
var HTTPRequestSuccessAction: [Int : (response:ResponseClass)->Void] = [:]
/// 每个实例化网络请求的错误执行闭包
var HTTPRequestErrorAction: [Int: (errorType:ERRORMsgType)->Void] = [:]

/// 网络请求类
public class HTTPRequestWithAlamofire: NSObject {
    var GLOBAL_THIS_APPID = "082D63FA-B62F-4228-B758-B4D573AC2870"
    //MARK:参数列表声明
    /// 变量记录是否需要提示错误信息
    var alertinfoShouldShow:HTTPERRORInfoShow!
    /// 记录哪个页面发起的调用，可以为NIL
    var viewcontroller:UIViewController?
    /// 发起请求的URL
    var url:String!
    /// 参数列表可以为NIL
    var params:[String:AnyObject]?
    /// 请求头部可以为NIL
    var header:[String : String]?
    
    //MARK:构造方法声明
    /**
    init
    
    - returns: self
    */
    public override init() {
        super.init()
    }
    
    /**
     需要准确判断网络，成功、失败俩闭包的网络请求方法
     
     - parameter alertinfoShouleShow: 是否需要展示错误信息
     - parameter viewcontroller:      那个控制器调用的此方法
     - parameter url:                 URL
     - parameter params:              参数
     - parameter header:              HEADER
     - parameter successAction:       成功闭包
     - parameter errorAction:         失败闭包
     */
    public func startRequest(alertinfoShouldShow:HTTPERRORInfoShow = HTTPERRORInfoShow.shouldShow,viewcontroller:UIViewController?,url:String, params:[String:AnyObject]?,header:[String : String]?,successAction:(response:ResponseClass)->Void,errorAction:(errorType:ERRORMsgType)->Void) {
        self.alertinfoShouldShow = alertinfoShouldShow
        self.viewcontroller = viewcontroller
        self.url = url
        self.params = params
        self.header = header
        HTTPRequestSuccessAction[self.hashValue] = successAction
        HTTPRequestErrorAction[self.hashValue] = errorAction
        //09.8 调用了新的PING功能
        RealReachability.sharedInstance().hostForPing = "www.baidu.com"
        RealReachability.sharedInstance().startNotifier()
        RealReachability.sharedInstance().reachabilityWithBlock { (statue) -> Void in
            if statue != ReachabilityStatus.RealStatusNotReachable {
                self.AlamofireRequestwithSuccessAndErrorClosure(self.alertinfoShouldShow, viewcontroller: self.viewcontroller, url: self.url, params: self.params, header: self.header, successAction: HTTPRequestSuccessAction[self.hashValue]!, errorAction: HTTPRequestErrorAction[self.hashValue]!)
            }else{
                //一次PING失败会发起第二次ping，两次PING连续失败的几率可以忽略<这里需要放到主线程中操作，因为有可能是主线程操作！>
                dispatch_after(1, dispatch_get_main_queue(), { () -> Void in
                    RealReachability.sharedInstance().reachabilityWithBlock { (statue) -> Void in
                        if statue != ReachabilityStatus.RealStatusNotReachable {
                            self.AlamofireRequestwithSuccessAndErrorClosure(self.alertinfoShouldShow, viewcontroller: self.viewcontroller, url: self.url, params: self.params, header: self.header, successAction: HTTPRequestSuccessAction[self.hashValue]!, errorAction: HTTPRequestErrorAction[self.hashValue]!)
                        }else{
                            NETWORKErrorProgress().errorMsgProgress(ERRORMsgType.networkCannotuse,ifcanshow: self.alertinfoShouldShow,errormsg:"",errorAction:HTTPRequestErrorAction[self.hashValue]!)
                        }
                    }
                })
            }
        }
    }
    
    //MARK:真正的网络请求方法
    /**
    网络请求，包含成功、失败两个闭包
    
    - parameter url:           请求URL
    - parameter params:        参数列表
    - parameter successAction: 成功闭包
    - parameter errorAction:   失败闭包
    */
    private func AlamofireRequestwithSuccessAndErrorClosure(alertinfoShouleShow:HTTPERRORInfoShow = HTTPERRORInfoShow.shouldShow,viewcontroller:UIViewController?,url:String, params:[String:AnyObject]?,header:[String : String]?,successAction:(response:ResponseClass)->Void,errorAction:(errorType:ERRORMsgType)->Void) {
        //在参数列表中添加全局变量
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            Alamofire.request(.POST, url, parameters: params!, encoding: ParameterEncoding.JSON, headers: header).responseData { (response) -> Void in
                if nil == response.data {
                    //返回数据为nil，在这里处理，不需要返回每个页面处理，进行ALERT即可 [ 非20x 返回值，应当查看Response的确切说明！]
                    NETWORKErrorProgress().errorMsgProgress(ERRORMsgType.responseError, ifcanshow: alertinfoShouleShow,errormsg:"",errorAction:errorAction)
                    return
                }
                do {
                    let changeData = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions.MutableContainers)
                    if changeData.isKindOfClass(NSDictionary) {
                        successAction(response: ResponseFactoary().responseInstance(ResponseType.DIC,data: changeData as! NSDictionary,alertinfoshouldshow: alertinfoShouleShow,errorAction:errorAction))
                    }
                    if changeData.isKindOfClass(NSArray) {
                        successAction(response: ResponseFactoary().responseInstance(ResponseType.ARRAY,data: changeData as! NSArray,alertinfoshouldshow: alertinfoShouleShow,errorAction:errorAction))
                    }
                    if changeData.isKindOfClass(NSString) {
                        successAction(response: ResponseFactoary().responseInstance(ResponseType.STRING,data: changeData as! String,alertinfoshouldshow: alertinfoShouleShow,errorAction:errorAction))
                    }
                }catch let error as NSError{
                    //转换数据失败，多为JSON字符问题，可发送到 http://www.bejson.com/ 进行校验，analyze
                    NETWORKErrorProgress().errorMsgProgress(ERRORMsgType.progressError,ifcanshow: alertinfoShouleShow,errormsg: "\(error)",errorAction:errorAction)
                }
            }
        }
    }
}





