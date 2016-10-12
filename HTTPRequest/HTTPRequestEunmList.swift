//
//  HTTPRequestEunmList.swift
//  FSZCItem
//
//  Created by MrShan on 16/6/23.
//  Copyright © 2016年 Mrshan. All rights reserved.
//

import Foundation


/**
 返回类型枚举
 
 - DIC:    字典
 - STRING: 字符串
 - ARRAY:  数组
 - OTHERS: 其他
 */
public enum ResponseType {
    case DIC
    case STRING
    case ARRAY
    case OTHERS
}

/**
 网络接口返回数据错误处理枚举
 
 - networkCannotuse: 没有网络
 - progressError:    解析错误
 - responseError:    返回数据错误
 - jumpLogin:        跳转登录页面
 */
public enum ERRORMsgType {
    case networkCannotuse
    case progressError
    case responseError
    case jumpLogin
    case returnerrormsg
}

/**
 是否需要在基类中弹窗
 
 - shouldShow:  可以
 - mustNotShow: 不可以
 */
public enum HTTPERRORInfoShow {
    case shouldShow
    case mustNotShow
}