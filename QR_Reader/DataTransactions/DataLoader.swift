//
//  DataLoader.swift
//  QR_Reader
//
//  Created by MacBook Air on 29.01.2022.
//

import Foundation

public class DataLoader {
    @Published var userData = [TypeOfQr]()
    
    init() {
        load()
        sort()
    }
    
    func load() {
        if let fileLocation = Bundle.main.url(forResource: "myData", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: fileLocation)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([TypeOfQr].self, from: data)
                
                self.userData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
    
    func sort(){
        self.userData = self.userData.sorted(by: { $0.name < $1.name})
    }
  
}
