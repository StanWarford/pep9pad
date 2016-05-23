import UIKit

let oprndPatterns = ["\\bADD(A|SP|X)\\b|\\bAND(A|X)\\b", "\\bASL(A|X)\\b", "\\bASR(A|X)\\b", "\\bBR\\b", "\\bBR(C|EQ|GE|GT|LE|LT|NE|V)\\b", "\\bCALL\\b", "\\bCPB(A|X)\\b", "\\bCPW(A|X)\\b", "\\bDEC(I|O)\\b", "\\bHEXO\\b", "\\bLDB(A|X)\\b", "\\bLDW(A|X)\\b", "\\bMOV(FLGA|AFLG|SPA)\\b", "\\bNEG(A|X)\\b", "\\bNOP\\b", "\\bNOP(0|1)\\b", "\\bNOT(A|X)\\b", "\\bOR(A|X)\\b", "\\bRET\\b", "\\bRETTR\\b", "\\bROL(A|X)\\b", "\\bROR(A|X)\\b", "\\bSTB(A|X)\\b", "\\bSTOP\\b", "\\bSTRO\\b", "\\bSTW(A|X)\\b", "\\bSUB(A|X|SP)\\b"]

let oprnds = "\\bADD(A|SP|X)\\b|\\bAND(A|X)\\b|\\bASL(A|X)\\b|\\bASR(A|X)\\b|\\bBR\\b|\\bBR(C|EQ|GE|GT|LE|LT|NE|V)\\b|\\bCALL\\b|\\bCPB(A|X)\\b|\\bCPW(A|X)\\b|\\bDEC(I|O)\\b|\\bHEXO\\b|\\bLDB(A|X)\\b|\\bLDW(A|X)\\b|\\bMOV(FLGA|AFLG|SPA)\\b|\\bNEG(A|X)\\b|\\bNOP\\b|\\bNOP(0|1)\\b|\\bNOT(A|X)\\b|\\bOR(A|X)\\b|\\bRET\\b|\\bRETTR\\b|\\bROL(A|X)\\b|\\bROR(A|X)\\b|\\bSTB(A|X)\\b|\\bSTOP\\b|\\bSTRO\\b|\\bSTW(A|X)\\b|\\bSUB(A|X|SP)\\b"


var oprndRegExp = [NSRegularExpression]()
//for exp in oprndPatterns {
//    oprndRegExp.append(try NSRegularExpression(pattern: exp, options: .CaseInsensitive))
//}

oprndRegExp.append(try NSRegularExpression(pattern: oprnds, options: .CaseInsensitive))

let text: NSAttributedString = NSAttributedString(string: "ANDX here, d ; ADDA; ROLX RORA", attributes: nil)


func highlight(text: NSAttributedString) -> NSAttributedString {
    var newStrings: [NSAttributedString] = []
    let regex = oprndRegExp[0]
    //for regex in oprndRegExp {
        do {
            let results = regex.matchesInString(String(text), options: [], range: NSMakeRange(0, text.length))
            for str in results {
                newStrings.append(text.attributedSubstringFromRange(str.range))
            }
            return NSAttributedString(string: "")
            //return results.map {NSAttributedString; (text.substringWithRange($0.range)}
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            return NSAttributedString(string: "")
        } catch {
            print("Another error")
            return NSAttributedString(string: "")
        }
        
        
    //}

}


highlight(text)



//let regexp = try NSRegularExpression(pattern: oprndPatterns[0], options: .CaseInsensitive)

// This function is not suitable, as it creates a local regex.
func matchesForRegexInText(regex: String!, text: String!) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex, options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text,
                                            options: [], range: NSMakeRange(0, nsString.length))
        return results.map { nsString.substringWithRange($0.range)}
    } catch let error as NSError {
        print("invalid regex: \(error.localizedDescription)")
        return []
    } catch {
        print("Another error")
        return []
    }
}



//matchesForRegexInText(oprndPatterns[0], text: str as String)
