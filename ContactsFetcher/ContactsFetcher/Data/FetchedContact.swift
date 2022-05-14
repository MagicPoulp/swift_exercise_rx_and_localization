//
//  FetchedContact.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

struct FetchedContact {
    var firstname: String
    var lastname: String
    var email: String
    
    // the dictionary allows us to us a dynamic variable name to access
    // https://stackoverflow.com/questions/46597624/can-swift-convert-a-class-struct-data-into-dictionary
    var asDictionary : [String: Any] {
      let mirror = Mirror(reflecting: self)
      let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
        guard let label = label else { return nil }
        return (label, value)
      }).compactMap { $0 })
      return dict
    }
}
