//
//  HTTPMethods.swift
//  AlamoreFireHTTPRequest
//
//  Created by Huy Bui Thanh on 23/09/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI

struct User: Codable {
    var id: Int?
    var userName: String
  
  init(userName: String) {
       self.userName = userName
  }

}

// MARK: Class observer
class observer: ObservableObject {
    @Published var movies = [Movie]()
    @Published var downloadProgress: Double = 0.0
    
    // Initialize to fetch movies
    init() {
        fetchMovies()
    }
    
    // MARK: Function download file
    func downloadFile(){
        let queue = DispatchQueue(label: "alamofire", qos: .utility)
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        print("Downloading")
        AF.download("https://file-examples.com/storage/fe4999944e63361b793404c/2017/10/file_example_PNG_500kB.png", to: destination)
            .downloadProgress(queue: queue) { progress in
                print(progress.fractionCompleted)
                
                DispatchQueue.main.async {
                    self.downloadProgress = progress.fractionCompleted
                }
            }
            .response { response in
                print(response)
            }
    }
    
    // MARK: Function Posting API
    func URLSessionPostApi(userName: String){
          print("Posting")
             //request create
              let url = URL(string: "https://backend-ios.herokuapp.com/user")
               guard let requestUrl = url else { fatalError() }
               var request = URLRequest(url: requestUrl)
               request.httpMethod = "POST"
               // Set HTTP Request Header
               request.setValue("application/json", forHTTPHeaderField: "Accept")
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")
             
               
            // add json data to the end
            let newUser = User(userName: userName)
               let jsonData = try? JSONEncoder().encode(newUser)
               request.httpBody = jsonData
               
               
               //this will hit the request
               let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                       
                       if let error = error {
                           print("Error took place \(error)")
                           return
                       }
                       guard let data = data else {return}
                       do{
    //                       print("result",response)
                           //jsondecoder get the data
                           let todoItemModel = try JSONDecoder().decode(User.self, from: data)
                           print("Response data:\n \(todoItemModel)")
                           print("todoItemModel Title: \(todoItemModel.userName)")
                           print("todoItemModel id: \(todoItemModel.id ?? 0)")
                       }catch let jsonErr{
                           print(jsonErr)
                      }
                
               }
               task.resume()
    }
    
    // MARK: Post user
    func postUser() {
        let parameters: [String: Any] = [
            "userName": "check"
        ]
        
        AF.request("https://backend-ios.herokuapp.com/user", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
            }
    }
    
    // MARK: Function fetching movies
    func fetchMovies() {
        AF.request("https://backend-ios.herokuapp.com/movie?fbclid=IwAR2OetUECYxuzW7gBPspT9H8XWaoNa4kwhToxcb4g6Er3S31nTNcH8JJJ0s")
            .validate()
            .responseDecodable(of: Movie.self) { (data) in
                let json = try! JSON(data: data.data!)
    
                for i in json {
    
                    self.movies.append(Movie(movieID: i.1["movieId"].intValue, title: i.1["title"].stringValue, publishedDate: i.1["publishedDate"].stringValue, categories: i.1["categories"].stringValue, youtubeID: i.1["youtubeID"].stringValue, imageName: i.1["imageName"].stringValue, rating: i.1["rating"].doubleValue, welcomeDescription: i.1["welcomeDescription"].stringValue, creator: i.1["creator"].stringValue, castList: [CastList(castID: i.1["castID"].intValue, castName: i.1["castName"].stringValue, castImage: i.1["castImage"].stringValue)], genreList: [GenreList(genreID: i.1["genreID"].intValue, genreName: i.1["genreName"].stringValue)]))
                }
            }
    }
    
    // MARK: upload Fiels
    func upload(image: Data, to url: Alamofire.URLRequestConvertible, params: [String: Any]) {
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, with: url)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                //Do what ever you want to do with response
            })
    }
    
    func Post(imageOrVideo : UIImage?){

    let headers: HTTPHeaders = [
        /* "Authorization": "your_access_token",  in case you need authorization header */
        "Authorization": "6d207e02198a847aa98d0a2a901485a5",
        "Content-type": "multipart/form-data"
    ]

        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(imageOrVideo!.pngData()!, withName: "upload_data" , fileName: "file.png", mimeType: "image/png")
        },
            to: "https://backend-ios.herokuapp.com/user", method: .post , headers: headers)
            .response { resp in
                print(resp)

        }
}
    
}
