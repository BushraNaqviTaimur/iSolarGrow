//
//  MainAppNetworkingClass.swift
//  iSolarGrow
//
//  Created by Bushra  on 18/09/2024.
//

import Foundation
import SharedFramework

class MainAppNetworkingClass: ISolarCloudAPI {
    func login(userAccount: String, userPassword: String, completion: @escaping (Result<(token: String, userMasterOrgID: String), Error>) -> Void) {
        let url = URL(string: "https://gateway.isolarcloud.com.hk/v1/userService/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginRequest = LoginRequest(
            sysCode: "200",
            appkey: "ANDROIDE13EC118BD7892FE7AB5A3F20",
            userAccount: userAccount,
            userPassword: userPassword
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(loginRequest)
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                let token = loginResponse.resultData.token
                let userMasterOrgID = loginResponse.resultData.userMasterOrgID
                completion(.success((token, userMasterOrgID)))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
   

    func getPsList(token: String, orgID: String, completion: @escaping (Result<Int, Error>) -> Void) {
        // Define the API URL
        let url = URL(string: "https://gateway.isolarcloud.com.hk/v1/powerStationService/getPsList")!

        // Define the request body
        let requestBody = PsListRequest(
            sysCode: "200",
            appkey: "ANDROIDE13EC118BD7892FE7AB5A3F20",
            token: token,
            orgID: orgID
        )

        // Convert the request body to JSON
        let jsonData = try? JSONEncoder().encode(requestBody)

        // Create the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Create the URLSession data task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }

            // Check if data is received
            guard let data = data else {
                let noDataError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(noDataError))
                return
            }

            do {
                // Decode the response
                let response = try JSONDecoder().decode(PsListResponse.self, from: data)

                // Extract the ps_id from the response
                if let psID = response.resultData.pageList.first?.psID {
                    completion(.success(psID))
                } else {
                    let noPsIDError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "ps_id not found"])
                    completion(.failure(noPsIDError))
                }
            } catch {
                completion(.failure(error))
            }
        }

        // Start the task
        task.resume()
    }
    // Function to get psDetail
    func fetchPsDetail(psID: Int, token: String, completion: @escaping (Result<(p83076MapValue: Double, p83076MapUnit: String, todayEnergyValue: Double, todayEnergyUnit: String, monthEnergyValue: Double, monthEnergyUnit: String, homeUsageTodayValue: Double, homeUsageTodayUnit: String,p13141 : Double), Error>) -> Void) {
        let url = URL(string: "https://gateway.isolarcloud.com.hk/v1/powerStationService/getPsDetail")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "sys_code": "200",
            "appkey": "ANDROIDE13EC118BD7892FE7AB5A3F20",
            "ps_id": "\(psID)",
            "valid_flag": "1,3",
            "lang": "_en_US",
            "token": token
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultData = jsonResponse["result_data"] as? [String: Any] {
                    
                    // Extract p83076_map
                    let p83076MapValue = (resultData["p83076_map"] as? [String: Any])?["value"] as? String ?? "0"
                    let p83076MapUnit = (resultData["p83076_map"] as? [String: Any])?["unit"] as? String ?? ""
                    
                    // Extract today_energy
                    let todayEnergyValue = (resultData["today_energy"] as? [String: Any])?["value"] as? String ?? "0"
                    let todayEnergyUnit = (resultData["today_energy"] as? [String: Any])?["unit"] as? String ?? ""
                    
                    // Extract month_energy
                    let monthEnergyValue = (resultData["month_energy"] as? [String: Any])?["value"] as? String ?? "0"
                    let monthEnergyUnit = (resultData["month_energy"] as? [String: Any])?["unit"] as? String ?? ""
                    
                    // Extract homeUsageToday
                    let homeUsageTodayValue = (resultData["p83118_map"] as? [String: Any])?["value"] as? String ?? "0"
                    let homeUsageTodayUnit = (resultData["p83118_map"] as? [String: Any])?["unit"] as? String ?? ""
                    
                    //batteryPercentage
                    // Extract p13141 value from storage_inverter_data
                       var p13141Value = "0" // Default value
                       if let storageInverterData = resultData["storage_inverter_data"] as? [[String: Any]],
                          let firstInverter = storageInverterData.first {
                           p13141Value = firstInverter["p13141"] as? String ?? "0"
                       }
                    
                    let p83076Map = Double(p83076MapValue) ?? 0
                    let todayEnergy = Double(todayEnergyValue) ?? 0
                    let monthEnergy = Double(monthEnergyValue) ?? 0
                    let homeUsageToday = Double(homeUsageTodayValue) ?? 0
                    let p13141 = Double(p13141Value) ?? 0
                    
                    completion(.success((p83076MapValue: p83076Map, p83076MapUnit: p83076MapUnit, todayEnergyValue: todayEnergy, todayEnergyUnit: todayEnergyUnit, monthEnergyValue: monthEnergy, monthEnergyUnit: monthEnergyUnit,homeUsageTodayValue: homeUsageToday, homeUsageTodayUnit: homeUsageTodayUnit,p13141 : p13141)))
                } else {
                    completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }




}
