
import Foundation

let green:(String)->(String) = { string in
    let ESCAPE = "\u{001b}["
    let RESET = ESCAPE + ";"
    return "\(ESCAPE)fg0,255,0;\(string)\(RESET)"
}

public func exampleOf(_ description: String, _ action: ()->()) {
    print("\n\(green(description))")
    action()
}
