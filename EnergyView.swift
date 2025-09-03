//
//  EnergyView.swift
//  iSolarGrow
//
//  Created by Bushra  on 18/09/2024.
//
import SwiftUI
import SharedFramework


struct EnergyView: View {
    @State private var CurrentSolarPower: Double?
    @State private var CurrentSolarPowerunit: String?
    @State private var SolarGeneratedtoday: Double?
    @State private var SolarGeneratedtodayunit: String?
    @State private var monthEnergy: Double?
    @State private var monthEnergyunit: String?
    @State private var HomeUsageToday: Double?
    @State private var HomeUsageTodayunit: String?
    @State private var batterypercentage: Double?
    
    var body: some View {
        VStack {
            
            if let CurrentSolarPower = CurrentSolarPower {
                HStack{
                    Text("Current Solar Power: \(String(format: "%.1f", CurrentSolarPower))")
                    Text(CurrentSolarPowerunit ?? "")
                }
               // .font(.largeTitle)
                .padding()
             
            } else {
                Text("Current Solar Power...")
                    //.font(.title)
                    .padding()
            }
            
            if let SolarGeneratedtoday = SolarGeneratedtoday {
                HStack{
                    Text("Energy Generated Today: \(String(format: "%.1f", SolarGeneratedtoday))")
                    Text(SolarGeneratedtodayunit ?? "")
                }
                   // .font(.title)
                    .padding()
                
            } else {
                Text("Loading Today's Energy...")
                   // .font(.title)
                    .padding()
            }
            
            if let monthEnergy = monthEnergy {
                HStack{
                    Text("Energy Generated This Month: \(String(format: "%.1f", monthEnergy))")
                    Text(monthEnergyunit ?? "")
                }
                    //.font(.title)
                    .padding()
            } else {
                Text("Loading Monthly Energy...")
                  //  .font(.title)
                    .padding()
            }
            
            if let HomeUsageToday = HomeUsageToday {
                HStack{
                    Text("Home Usage Today: \(String(format: "%.1f", HomeUsageToday))")
                    Text(HomeUsageTodayunit ?? "")
                }
                    //.font(.title)
                    .padding()
            } else {
                Text("Loading Home Usage Today...")
                  //  .font(.title)
                    .padding()
            }
            if let batterypercentage = batterypercentage {
               
                    Text("Battery Percentage: \(Int(batterypercentage))%")
                   
                
                    //.font(.title)
                    .padding()
            } else {
                Text("Loading Battery Percentage...")
                  //  .font(.title)
                    .padding()
            }
            
        }
        .onAppear {
            fetchEnergyData()
        }
    }
   private func fetchEnergyData() {
        //let api = ISolarCloudAPI()
       let api: ISolarCloudAPI = MainAppNetworkingClass()
        // Perform login
        api.login(userAccount: "masad@live.com", userPassword: "281544Zt") { result in
            switch result {
            case .success(let (token, userMasterOrgID)):
                print("Token: \(token)")
                print("User Master Org ID: \(userMasterOrgID)")
                UserDefaults.standard.set(token, forKey: "userToken")
                UserDefaults.standard.set(userMasterOrgID, forKey: "userMasterOrgID")
            case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
            }
        }//login

        // Fetch the saved token and userMasterOrgID from UserDefaults
        guard let token = UserDefaults.standard.string(forKey: "userToken"),
              let userMasterOrgID = UserDefaults.standard.string(forKey: "userMasterOrgID") else {
            print("Token or User Master Org ID not found.")
            return
        }
        
        // Pass token and userMasterOrgID to the getPsList API
        api.getPsList(token: token, orgID: userMasterOrgID) { result in
            switch result {
            case .success(let psID):
                print("PS ID: \(psID)")
//                UserDefaults.standard.set(psID, forKey: "psID")
//                let sharedDefaults = UserDefaults(suiteName: "group.com.SolarGrow.solarData")
//                sharedDefaults?.set(token, forKey: "userToken")
//                sharedDefaults?.set(userMasterOrgID, forKey: "userMasterOrgID")
//                sharedDefaults?.set(psID, forKey: "psID")
                
                // Fetch energy details using the retrieved PS ID
                                  api.fetchPsDetail(psID: psID, token: token) { result in
                                      switch result {
                                      case .success(let (p83076MapValue, p83076MapUnit, todayEnergyValue, todayEnergyUnit, monthEnergyValue, monthEnergyUnit,homeUsageTodayValue,homeUsageTodayUnit,p13141)):
                                          DispatchQueue.main.async {
                                              self.CurrentSolarPower = p83076MapValue
                                              self.CurrentSolarPowerunit = p83076MapUnit
                                              self.SolarGeneratedtoday = todayEnergyValue
                                              self.SolarGeneratedtodayunit = todayEnergyUnit
                                              self.monthEnergy = monthEnergyValue
                                              self.monthEnergyunit = monthEnergyUnit
                                              self.HomeUsageToday = homeUsageTodayValue
                                              self.HomeUsageTodayunit = homeUsageTodayUnit
                                              self.batterypercentage = p13141
                                              // Optionally, save units if needed
                                              
                                          }
                                      case .failure(let error):
                                          DispatchQueue.main.async {
                                              print("Failed to fetch energy data with error: \(error.localizedDescription)")
                                          }
                                      }
                                  }
                
            case .failure(let error):
                print("Failed to get PS List with error: \(error.localizedDescription)")
            }
        }
    }
//fetchenergy

}
