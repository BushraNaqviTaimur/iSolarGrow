//
//  LoginModel.swift
//  iSolarGrow
//
//  Created by Bushra  on 18/09/2024.
//

import Foundation
//import SharedFramework

 public struct LoginRequest: Codable {
    let sysCode: String
    let appkey: String
    let userAccount: String
    let userPassword: String

    enum CodingKeys: String, CodingKey {
        case sysCode = "sys_code"
        case appkey
        case userAccount = "user_account"
        case userPassword = "user_password"
    }
}

public struct LoginResponse: Codable {
    let reqSerialNum, resultCode, resultMsg: String
    let resultData: ResultData
    
    enum CodingKeys: String, CodingKey {
        case reqSerialNum = "req_serial_num"
        case resultCode = "result_code"
        case resultMsg = "result_msg"
        case resultData = "result_data"
    }
    
    
    struct ResultData: Codable {
        let token: String
        let userMasterOrgID: String
        
        enum CodingKeys: String, CodingKey {
            case token
            case userMasterOrgID = "user_master_org_id"
        }
    }
}
