//
//  HTTPRequestResponseProgress.swift
//  FSZCItem
//
//  Created by MrShan on 16/6/23.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import Foundation
import UIKit

public class NETWORKErrorProgress: NSObject {
    
    /**
     异常错误处理方法
     
     - parameter type:      错误类型
     - parameter ifcanshow: 是否可以提示错误
     - parameter errormsg:  错误信息
     */
    func errorMsgProgress(type:ERRORMsgType,ifcanshow:HTTPERRORInfoShow,errormsg:String,errorAction:(errorType:ERRORMsgType)->Void){
        if type == ERRORMsgType.jumpLogin {
            self.moreThanoneUserLoginwithsameoneAPPID()
        }else{
            if type == ERRORMsgType.networkCannotuse && ifcanshow == HTTPERRORInfoShow.shouldShow {
                //MyAlertView.sharedInstance.show(MyAlertViewType.blackViewAndClickDisappear, contentType: MyAlertContentViewType.warning, message: ["没有网络连接，请检查您的网络"])

                errorAction(errorType:ERRORMsgType.networkCannotuse)
            }
            if type == ERRORMsgType.responseError && ifcanshow == HTTPERRORInfoShow.shouldShow {
                //MyAlertView.sharedInstance.show(MyAlertViewType.blackViewAndClickDisappear, contentType: MyAlertContentViewType.warning, message: ["网络通讯异常，请重试。"])

                errorAction(errorType:ERRORMsgType.responseError)
            }
            if type == ERRORMsgType.progressError && ifcanshow == HTTPERRORInfoShow.shouldShow {
                //MyAlertView.sharedInstance.show(MyAlertViewType.blackViewAndClickDisappear, contentType: MyAlertContentViewType.warning, message: ["\(errormsg)解析数据错误"])

                errorAction(errorType:ERRORMsgType.progressError)
            }
            if type == ERRORMsgType.returnerrormsg && ifcanshow == HTTPERRORInfoShow.shouldShow {
                //MyAlertView.sharedInstance.show(MyAlertViewType.blackViewAndClickDisappear, contentType: MyAlertContentViewType.warning, message: ["\(errormsg)"])

                errorAction(errorType:ERRORMsgType.returnerrormsg)
            }
        }
    }
    
    /**
     多账户登录的时候，接口返回999数据的时候需要跳转到登录页面
     */
    func moreThanoneUserLoginwithsameoneAPPID() {
        //跳到登录页面
//        MyAlertView.sharedInstance.hiden()
//        let drawCon = UIApplication.sharedApplication().keyWindow?.rootViewController as! MMDrawerController
//        let navCon = drawCon.centerViewController as! MMNavigationController
//        if(isLeftPersonalCenter){
//            isLeftPersonalCenter = false
//            is999Login = false
//            
//            let leftCon = drawCon.leftDrawerViewController as! PersonalCenterViewController
//            leftCon.delay(0.5, closure: { () -> () in
//                leftCon.mm_drawerController.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: { (bo) -> Void in
//                    navCon.viewControllers.last!.navigationController!.pushViewController(QuickLoginViewController(nibName: "QuickLoginViewController", bundle: nil), animated: true)
//                })
//                return
//            })
//        }
//        if(is999Login){
//            is999Login = false
//            navCon.viewControllers.last!.navigationController!.pushViewController(QuickLoginViewController(nibName: "QuickLoginViewController", bundle: nil), animated: true)
//        }else{
//        }
    }
}