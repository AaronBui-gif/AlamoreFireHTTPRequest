//
//  ContentView.swift
//  AlamoreFireHTTPRequest
//
//  Created by Huy Bui Thanh on 23/09/2022.
//

import SwiftUI
import Alamofire
import SwiftyJSON
import SDWebImageSwiftUI


struct ContentView: View {
    @ObservedObject var obs = observer()
    @State var imageData: UIImage?
    @State private var imageSaved: Bool = false

    var body: some View {
        NavigationView{
            WebImage(url: URL(string: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80"))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .onTapGesture {
                    imageData = UIImage(data: try! Data(contentsOf: URL(string: "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8&w=1000&q=80")!))
                    saveImage()
                
                }
            
            List(obs.movies) {i in
                card(name: i.title)
            }.navigationTitle("Json Parse ")
            Button("Save Image") {
                saveImage()
            }
        }.onAppear{
//            obs.downloadFile()
//            obs.postUser()
           
        }
        
    }
    
    // save Image to Photo Album
    func saveImage() {
        let imageSaver = ImageSaver()
        if let uiImage = imageData {
            print("Saving Image to Photo Album")
            imageSaver.writeToPhotoAlbum(image: uiImage)
            imageSaved = true
            print("Uploading image")
            obs.Post(imageOrVideo: uiImage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct card : View {
    var name = ""
//    var url = ""
//
    var body: some View {
        HStack {
//            WebImage(url: URL(string: url))
//                .resizable()
//                .frame(width: 200, height: 200)
            Text(name).fontWeight(.bold)
        }
    }
}

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}

class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("save finished")
    }
}
