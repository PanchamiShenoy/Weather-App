//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Panchami Shenoy on 02/02/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class NetworkManager {
    static let shared = NetworkManager()
    var newData: WeatherResults?
    func getDataWithCityName(city: String, completionHandler: @escaping (WeatherResults?,Error?)-> Void ) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=ad0759d957e09204e3bebf5f5a1ea289"
        
        guard let urlToSend = URL(string: url) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlToSend) { data, response, error in
            if let error = error {
                completionHandler(nil,error)
            }
            
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.newData = try decoder.decode(WeatherResults.self, from: data)
                }catch{
                    print("failed",error.localizedDescription)
                }
            }
            guard let decodedResults = self.newData else{
                return
            }
            completionHandler(decodedResults,nil)
        }
        task.resume()
        
    }
    
    func writeDocument(documentName: String, data: [String: Any]) {
        let db = Firestore.firestore()
        db.collection(documentName).addDocument(data: data)
    }
    
    func readDocument() {
        
    }
    
    func addFavLocation(location:[String: Any], uid: String){
        let db = Firestore.firestore()
        db.collection(uid).addDocument(data:location)
    }
    
    func deleteFavLocation(location:FavLocationDetail) {
        guard let userId = Auth.auth().currentUser?.uid else { return  }
        let db = Firestore.firestore()
        db.collection(userId).document(location.documentid).delete { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkSignIn() ->Bool {
        if Auth.auth().currentUser?.uid != nil {
            return true
        }
        else{
            return false
        }
    }
    
    func getUserName() -> String {
       return Auth.auth().currentUser?.displayName ?? ""
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        }
        catch {
            
        }
    }
    
    func fetchFavLocatiom(completion :@escaping([FavLocationDetail])->Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return  }
        let db = Firestore.firestore()
        var favLocations = [FavLocationDetail]()
        db.collection(userId).getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let data = document.data()
                    print(data)
                    let locationDeatil = FavLocationDetail(documentid: document.documentID, location: (data["location"] as! String))
                    favLocations.append(locationDeatil )
                }
                
            }
            completion(favLocations)
        }
        
    }
    
    func SignIn(email: String, password: String, completeionHandler: @escaping(((AuthDataResult?, Error?) -> Void))) {
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] result, error in
            completeionHandler(result,error)
        }
    }
    
    func SignUp(email: String, password: String, completeionHandler: @escaping(((AuthDataResult?, Error?) -> Void))) {
        Auth.auth().createUser(withEmail: email, password: password) {result,error in
            completeionHandler(result,error)
        }
    }
}
