//
//  EnergyDetailModel.swift
//  iSolarGrow
//
//  Created by Bushra  on 18/09/2024.
//

import Foundation
import Foundation


// Define the model to match the API response
public struct ApiResponse: Codable {
    let req_serial_num: String
    let result_code: String
    let result_msg: String
    let result_data: ResultData?
    
    struct ResultData: Codable {
       // let total_energy: Energy?
        let today_energy: Energy?
        let month_energy: Energy?
        let p83076_map: Energy?
    }
    
    struct Energy: Codable {
        let unit: String
        let value: String
    }
}
