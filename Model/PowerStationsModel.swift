//
//  PowerStationsModel.swift
//  iSolarGrow
//
//  Created by Bushra  on 18/09/2024.
//

import Foundation

public struct PsListRequest: Codable {
    let sysCode: String
    let appkey: String
    let token: String
    let orgID: String

    enum CodingKeys: String, CodingKey {
        case sysCode = "sys_code"
        case appkey
        case token
        case orgID = "org_id"
    }
}
public struct PsListResponse: Codable {
    let reqSerialNum: String
    let resultCode: String
    let resultMsg: String
    let resultData: ResultData
    
    enum CodingKeys: String, CodingKey {
        case reqSerialNum = "req_serial_num"
        case resultCode = "result_code"
        case resultMsg = "result_msg"
        case resultData = "result_data"
    }
    
    
    struct ResultData: Codable {
        let pageList: [PageList]
        let rowCount: Int
    }
    
    struct PageList: Codable {
        let psID: Int
        
        enum CodingKeys: String, CodingKey {
            case psID = "ps_id"
        }
    }
}
