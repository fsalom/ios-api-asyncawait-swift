import Foundation

struct Cache {
    enum Key: String {
        case refreshToken
        case accessToken
        case expiresIn
        case logged
        case userID
    }

    static func set(_ key: Key, _ value: Any?) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    static func get(stringFor: Key) -> String? {
        return UserDefaults.standard.string(forKey: stringFor.rawValue)
    }

    static func get(intFor: Key) -> Int {
        return UserDefaults.standard.integer(forKey: intFor.rawValue)
    }

    static func get(doubleFor: Key) -> Double {
        return UserDefaults.standard.double(forKey: doubleFor.rawValue)
    }

    static func get(floatFor: Key) -> Float {
        return UserDefaults.standard.float(forKey: floatFor.rawValue)
    }

    static func get(boolFor: Key) -> Bool {
        return UserDefaults.standard.bool(forKey: boolFor.rawValue)
    }

    static func get(arrayFor: Key) -> [Any]? {
        return UserDefaults.standard.array(forKey: arrayFor.rawValue)
    }

    static func get(anyFor: Key) -> Any? {
        return UserDefaults.standard.object(forKey: anyFor.rawValue) as Any
    }

    static func get(dictionaryArrayFor: Key) -> [String: [Any]]? {
        return UserDefaults.standard.dictionary(forKey: dictionaryArrayFor.rawValue) as? [String: [Any]]
    }

    static func get(dictionaryFor: Key) -> [String: Any]? {
        return UserDefaults.standard.dictionary(forKey: dictionaryFor.rawValue)
    }

    static func printAll() {
        print("[CacheHandler] Print Userdefaults:")
        print("------------------------------------")
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value)")
        }
        print("------------------------------------")
    }

    static func clear() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    static func logOut() {
        Cache.set(.logged, false)
        Cache.set(.userID, nil)
    }
}
