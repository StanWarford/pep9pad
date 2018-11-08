//
//  pep9pad
//
//  Copyright © 2016 Pepperdine University. All rights reserved.
//

import Foundation

//pep9 computer
enum Figures: String {
    
    case FIG433  = "Figure 4.33"
    case FIG435  = "Figure 4.35"
    case FIG436  = "Figure 4.36"
    case FIG437  = "Figure 4.37"
    case FIG503  = "Figure 5.03"
    case FIG506  = "Figure 5.06"
    case FIG507  = "Figure 5.07"
    case FIG510  = "Figure 5.10"
    case FIG511  = "Figure 5.11"
    case FIG512  = "Figure 5.12"
    case FIG513  = "Figure 5.13"
    case FIG514a = "Figure 5.14a"
    case FIG514b = "Figure 5.14b"
    case FIG515  = "Figure 5.15"
    case FIG516  = "Figure 5.16"
    case FIG519  = "Figure 5.19"
    case FIG522  = "Figure 5.22"
    case FIG527  = "Figure 5.27"
    case FIG601  = "Figure 6.01"
    case FIG604  = "Figure 6.04"
    case FIG606  = "Figure 6.06"
    case FIG608  = "Figure 6.08"
    case FIG610  = "Figure 6.10"
    case FIG612  = "Figure 6.12"
    case FIG614  = "Figure 6.14"
    case FIG616  = "Figure 6.16"
    case FIG618  = "Figure 6.18"
    case FIG621  = "Figure 6.21"
    case FIG623  = "Figure 6.23"
    case FIG625  = "Figure 6.25"
    case FIG627  = "Figure 6.27"   // Interactive input
    case FIG629  = "Figure 6.29"   // Interactive input
    case FIG632  = "Figure 6.32"
    case FIG634  = "Figure 6.34"
    case FIG636  = "Figure 6.36"
    case FIG638  = "Figure 6.38"
    case FIG640  = "Figure 6.40"   // Interactive input
    case FIG642  = "Figure 6.42"
    case FIG644  = "Figure 6.44"
    case FIG646  = "Figure 6.46"
    case FIG648  = "Figure 6.48"
    
    static let allValues = [
        FIG433,
        FIG435,
        FIG436,
        FIG437,
        FIG503,
        FIG506,
        FIG507,
        FIG510,
        FIG511,
        FIG512,
        FIG513,
        FIG514a,
        FIG514b,
        FIG515,
        FIG516,
        FIG519,
        FIG522,
        FIG527,
        FIG601,
        FIG604,
        FIG606,
        FIG608,
        FIG610,
        FIG612,
        FIG614,
        FIG616,
        FIG618,
        FIG621,
        FIG623,
        FIG625,
        FIG627,
        FIG629,
        FIG632,
        FIG634,
        FIG636,
        FIG638,
        FIG640,
        FIG642,
        FIG644,
        FIG646,
        FIG648
    ]

}



enum Problems: String {
    
    case EXER804 = "Exercise 8.04"
    case PROB826 = "Problem 8.26"
    case PROB827 = "Problem 8.27"
    case PROB828 = "Problem 8.28"
    case PROB829 = "Problem 8.29"
    case PROB830 = "Problem 8.30"
    case PROB831 = "Problem 8.31"
    case PROB832 = "Problem 8.32"

    static let allValues = [
        EXER804,
        PROB826,
        PROB827,
        PROB828,
        PROB829,
        PROB830,
        PROB831,
        PROB832
    ]

}

enum ProblemDescriptions: String {
    case EXER804 = "An excercise for the DECI trap."
    case PROB826 = "A test driver for the ASL2 instruction."
    case PROB827 = "A test driver for the ASLMANY instruction."
    case PROB828 = "A test driver for the MULA instruction."
    case PROB829 = "A test driver for the STWADI instruction."
    case PROB830 = "A test driver for the BOOLO instruction."
    case PROB831 = "A test driver for the STKADD instruction."
    case PROB832 = "A test driver for the XORA instruction."
    
    static let allValues = [
        EXER804,
        PROB826,
        PROB827,
        PROB828,
        PROB829,
        PROB830,
        PROB831,
        PROB832
    ]

}

enum FigureDescriptions: String {
    case FIG433  = "A machine language program to output the characters Hi."
    case FIG435  = "A machine language program to input two characters and output them in reverse order."
    case FIG436  = "A machine language program to add 5 and 3 and output the single-character result."
    case FIG437  = "A machine language program that modifies itself. The add accumulator instruction changes to a subtract instruction."
    case FIG503  = "An assembly-language program to output Hi. It is the assembly-language version of Figure 4.33."
    case FIG506  = "An assembly language program to input two characters and output them in reverse order. It is the assembly language version of Figure 4.35."
    case FIG507  = "An assembly language program to add 3 and 5 and output the single-character result. It is the assembly language version of Figure 4.36."
    case FIG510  = "A program to output Hi using immediate addressing."
    case FIG511  = "A program to input a decimal value, add 1 to it, and output the sum."
    case FIG512  = "A program identical to that of Figure 5.11 but with the STRO instruction."
    case FIG513  = "A nonsense program to illustrate the interpretation of bit patterns."
    case FIG514a = "The first of two different source programs that produce the same object program and, therefore, the same output."
    case FIG514b = "The second of two different source programs that produce the same object program and, therefore, the same output."
    case FIG515  = "A program that adds 1 to a decimal value. It is identical to Figure 5.12 except that it uses symbols."
    case FIG516  = "A nonsense program that illustrates the underlying von Neumann nature of the machine."
    case FIG519  = "The cout statement."
    case FIG522  = "The assignment statement with global variables."
    case FIG527  = "C constants."
    case FIG601  = "Stack-relative addressing."
    case FIG604  = "Local variables."
    case FIG606  = "The if statement."
    case FIG608  = "The if/else statement."
    case FIG610  = "The while statement."
    case FIG612  = "The do statement."
    case FIG614  = "The for statement."
    case FIG616  = "A mystery program."
    case FIG618  = "A procedure call with no parameters."
    case FIG621  = "Call-by-value parameters with global variables."
    case FIG623  = "Call-by-value parameters with local variables."
    case FIG625  = "A recursive nonvoid function."
    case FIG627  = "Call-by-reference parameters with global variables."
    case FIG629  = "Call-by-reference parameters with local variables."
    case FIG632  = "Translation of a boolean type."
    case FIG634  = "A global array."
    case FIG636  = "A local array."
    case FIG638  = "Passing a local array as a parameter."
    case FIG640  = "Translation of a switch statement."
    case FIG642  = "Translation of global pointers."
    case FIG644  = "Translation of local pointers."
    case FIG646  = "Translation of a structure."
    case FIG648  = "Translation of a linked list."
    
    static let allValues = [
        FIG433,
        FIG435,
        FIG436,
        FIG437,
        FIG503,
        FIG506,
        FIG507,
        FIG510,
        FIG511,
        FIG512,
        FIG513,
        FIG514a,
        FIG514b,
        FIG515,
        FIG516,
        FIG519,
        FIG522,
        FIG527,
        FIG601,
        FIG604,
        FIG606,
        FIG608,
        FIG610,
        FIG612,
        FIG614,
        FIG616,
        FIG618,
        FIG621,
        FIG623,
        FIG625,
        FIG627,
        FIG629,
        FIG632,
        FIG634,
        FIG636,
        FIG638,
        FIG640,
        FIG642,
        FIG644,
        FIG646,
        FIG648
    ]

}


//CPU
//12.5 -- 12.14
enum OneByteExamples: String{
    case FIG1205 = "Figure 12.05"
    case FIG1207 = "Figure 12.07"
    case FIG1209 = "Figure 12.09"
    case FIG1210 = "Figure 12.10"
    case FIG1211 = "Figure 12.11"
    case FIG1212 = "Figure 12.12"
    case FIG1214 = "Figure 12.14"
    
    static let allValues = [
        FIG1205,
        FIG1207,
        FIG1209,
        FIG1210,
        FIG1211,
        FIG1212,
        FIG1214
    ]
    
}

enum OneByteDescriptions: String {
    case FIG1205 = "The control signals to fetch the instruction specifier and increment PC by 1."
    case FIG1207 = "Combining cycles of Figure 12.5."
    case FIG1209 = "The control signals to implement the store byte instruction with direct addressing."
    case FIG1210 = "The control signals to implement the store word instruction with direct addressing."
    case FIG1211 = "The control signals to implement the add instruction with immediate addressing."
    case FIG1212 = "The control signals to implement the load instruction with indirect addressing."
    case FIG1214 = "The control signals to implement the load unary ASRA instruction"
    
    static let allValues = [
        FIG1205,
        FIG1207,
        FIG1209,
        FIG1210,
        FIG1211,
        FIG1212,
        FIG1214
    ]
}

// 12.20 -- 12.23
enum TwoByteExamples: String{
    case FIG1220 = "Figure 12.20"
    case FIG1221 = "Figure 12.21"
    case FIG1223 = "Figure 12.23"
    
    static let allValues = [
        FIG1220,
        FIG1221,
        FIG1223
    ]
}


