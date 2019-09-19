//
//  ApiManager.swift
//  BindingProject
//
//  Created by Raunaque Quaiser on 18/09/19.
//  Copyright © 2019 Rajmaurya_Personal_inc. All rights reserved.
//

import Foundation

let ApiURl = "https://storage.googleapis.com/carousell-interview-assets/ios/ios-se-1a.json"

struct  DataModel:Codable {
    var content:String
    var image_url:String?
    var isLiked:Bool? = false
}


func  getDataFromApi(resultData:@escaping ([DataModel])->Void){
    
    guard let url  = URL(string:ApiURl) else{return }
    
    URLSession.shared.dataTask(with: url) { (data, responseData, error) in
        
        guard let responseData = data , error == nil  else{return}
            do {
                let decoder = JSONDecoder()
                let data =  try decoder.decode([DataModel].self, from: responseData)
                print(data)
                resultData(data)
            }
            catch let parssingErrre{
                print(parssingErrre.localizedDescription)
    }
    }.resume()
}
