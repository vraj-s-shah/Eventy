//
//  Realm.swift
//  Eventy
//
//  Created by Vraj Shah on 14/06/23.
//

import RealmSwift

let realmHelper = RealmHelper.shared

/**
 * Simulator realm file url:
 * 14 Pro max -
 * /Users/vraj/Library/Developer/CoreSimulator/Devices/0B1BD0EC-0F70-49E1-96EA-F4D258505A60/data/Containers/Data/Application/270141F0-7A45-4C81-A977-190EDD45CA53/Documents/
 */
class RealmHelper {
    
    //MARK: -
    //MARK: - Variables
    
    static let shared = RealmHelper()
    private var realm: Realm?
    
    //MARK: -
    //MARK: - Initialization
    
    init() {
        do {
            realm = try Realm()
        } catch {
            realm = nil
            debugPrint("Cannot create real instance: ", error.localizedDescription)
        }
    }
    
    //MARK: -
    //MARK: - Public functions
    
    func set<T: Object>(object: T) {
        guard let realm else { return }
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            print("Cannot write to realm")
        }
    }
    
    func get<T: Object>() -> Results<T>? {
        realm?.objects(T.self)
    }
    
    func get<T: Object>(_ predicateFormat: String, _ args: Any...) -> Results<T>? {
        realm?.objects(T.self).filter(predicateFormat, args)
    }
    
    func getFirst<T: Object>(_ predicateFormat: String, _ args: Any...) -> T? {
        realm?.objects(T.self).filter(predicateFormat, args).first
    }
    
    func get<T: Object>(primaryKey: Any) -> T? {
        realm?.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
}//End of class
