import Foundation

// MARK: Log For Debug
/// Prints to console on debug build configuration
public func DebugLog(_ obj: Any? = nil, file:String = #file, function:String = #function, line: Int = #line){
    #if DEBUG
    var filename:NSString = file as NSString
    filename = filename.lastPathComponent as NSString
    if let obj = obj{
        print("[File:\(filename) Func:\(function) Line:\(line)] : \(obj)")
    }else{
        print("[File:\(filename) Func:\(function) Line:\(line)]")
    }
    #endif
}
