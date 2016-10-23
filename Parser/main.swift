
import Foundation


var unaryOperations = ["sqr", "sqrt"]
var binaryOperations = ["+","-","*","/"]
var parenthesis = ["(",")"]
var digitStr = ""
var symbolStr = ""
var tempArray = [String]()
let priority = ["(":1, ")":1,"+":2, "*":3, "-":2, "/":3, "sqr":4, "sqrt":4]



func isDigit(char: Character) -> Bool{
    var res = false
    let digitString = "0123456789"
    let substr = digitString.range(of: String(char))
    if substr != nil {
        
        res = true
        
    }
    return res
}

func isUnaryOperation(str: String) -> Bool{
    
    var res = false
    for operation in unaryOperations {
        
        if str == operation {
            
            res = true
        }
        
    }
    return res
    
}

func isBinaryOperation(char: Character) -> Bool{
    
    var res = false
    for operation in binaryOperations {
        
        if String(char) == operation {
            
            res = true
        }
        
    }
    return res
    
}

func isParenthesis(char: Character) -> Bool {
    
    var res = false
    for operation in parenthesis {
        
        if String(char) == operation {
            
            res = true
        }
        
    }
    return res
    
}

func separateParenthesis(str: String)->[String]{
    var strArray = [String]()
    var strWithOutparenthesis = ""
    var lastParenthesis = false
    for char in str.characters {
        
        if isParenthesis(char: char) || isBinaryOperation(char: char){
            
            if !lastParenthesis && strWithOutparenthesis.characters.count > 0 {
                
                strArray.append(strWithOutparenthesis)
                strWithOutparenthesis = ""
                
            }
            strArray.append(String(char))
            lastParenthesis = true
            
        }
        else {
            
            strWithOutparenthesis += String(char)
            lastParenthesis = false
        }
        
    }
    if strWithOutparenthesis.characters.count > 0 {
        
        strArray.append(strWithOutparenthesis)
    }
    
    return strArray
}



func sortArrayToNPR(array: [String]) -> [String]{
    
    var arrOperand = [String]()
    var arrOperation = [String]()
    
    for item in array {
        
        if let digit = Double(item) {
            arrOperand.append(item)
        } else{
            if item == ")" {
                var lastElement = ""
                if arrOperation.count > 0 {
                    
                    repeat {
                        lastElement = arrOperation.removeLast()
                        if lastElement != "(" {
                            arrOperand.append(lastElement)
                        }
                        
                        
                    }while(lastElement != "(")
                }
                
            } else {
                if item != "(" {
                    let numberPriority = priority[item]
                    var countArray = arrOperation.count
                    var index = countArray - 1
                    while(index >= 0){
                        
                        let element = arrOperation[index]
                        if element == "(" {
                            break
                        }
                        if priority[element]! >= numberPriority! {
                            
                            arrOperand.append(element)
                            arrOperation.remove(at: index)
                            
                        }
                        
                        index -= 1
                    }
                }
                arrOperation.append(item)
            }
        }
        
    }
    
    for index in 0..<arrOperation.count {
        
        arrOperand.append(arrOperation[arrOperation.count - index - 1])
        
    }
    
    return arrOperand
}

func evaluate(mathOp: String, op1: String, op2: String = "") -> Double{
    
    var res:Double = 0
    switch mathOp {
        
    case "+" :
        res = Double(op1)! + Double(op2)!
    case "*" :
        res = Double(op1)! * Double(op2)!
    case "-" :
        res = Double(op1)! - Double(op2)!
    case "/" :
        res = Double(op1)! / Double(op2)!
    case "sqr":
        res = pow(Double(op1)!,2)
    case "sqrt":
        res = pow(Double(op1)!,0.5)
    default:
        return 0
        
    }
    
    return res
    
}

func evaluateArr(arrayNPR: [String]) -> [String]{
    var arrayNPR = arrayNPR
    
    if arrayNPR.count > 1 {
        
        for index in 0..<arrayNPR.count {
            
            if let digit = Double(arrayNPR[index]) {
                
            } else{
                
                if isUnaryOperation(str: arrayNPR[index]) {
                    
                    let op1 = arrayNPR[index - 1]
                    let res = evaluate(mathOp: arrayNPR[index], op1: op1)
                    arrayNPR.remove(at: index - 1)
                    arrayNPR.remove(at: index - 1)
                    arrayNPR.insert(String(res), at: index - 1)
                    break
                    
                }
                else {
                    
                    let op1 = arrayNPR[index - 2]
                    let op2 = arrayNPR[index - 1]
                    let res = evaluate(mathOp: arrayNPR[index], op1: op1, op2: op2)
                    arrayNPR.remove(at: index - 2)
                    arrayNPR.remove(at: index - 2)
                    arrayNPR.remove(at: index - 2)
                    arrayNPR.insert(String(res), at: index - 2)
                    break
                }
            }
        }
        arrayNPR = evaluateArr(arrayNPR: arrayNPR)
        
    }
    
    return arrayNPR
}

func parseAndCalculateStr(str: String) -> Double {

    let arr = separateParenthesis(str: str)
    let arrNPR = sortArrayToNPR(array: arr)
    let result = evaluateArr(arrayNPR: arrNPR)
    if result.count > 0 {
    
        return Double(result[0])!
    } else {
    
        return 0
    
    }
}

print("Input math string:")

if let str = readLine() {
    print(str)
    print("Result is: \(parseAndCalculateStr(str: str))")
}






