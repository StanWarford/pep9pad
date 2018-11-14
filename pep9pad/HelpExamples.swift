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

enum TwoByteDescriptions : String {
    
    case FIG1220 = "The fetch and increment part of the von Neumann cycle with the two-byte data bus."
    case FIG1221 = "The fetch and increment part of the von Neumann cycle with pre-fetched instruction specifier."
    case FIG1223 = "The two-byte bus implementation of the load word instruction with indirect addressing."
    
    static let allValues = [
        FIG1220,
        FIG1221,
        FIG1223
    ]
}

enum OneByteProblems : String {
    case PROB1228 = "Problem 12.28"
    case PROB1229a = "Problem 12.29a"
    case PROB1229b = "Problem 12.29b"
    case PROB1229c = "Problem 12.29c"
    case PROB1229d = "Problem 12.29d"
    case PROB1229e = "Problem 12.29e"
    case PROB1229f = "Problem 12.29f"
    case PROB1229g = "Problem 12.29g"
    case PROB1230 = "Problem 12.30"
    case PROB1231a = "Problem 12.31a"
    case PROB1231b = "Problem 12.31b"
    case PROB1231c = "Problem 12.31c"
    case PROB1231d = "Problem 12.31d"
    case PROB1231e = "Problem 12.31e"
    case PROB1231f = "Problem 12.31f"
    case PROB1231g = "Problem 12.31g"
    case PROB1232a = "Problem 12.32a"
    case PROB1232b = "Problem 12.32b"
    case PROB1232c = "Problem 12.32c"
    case PROB1232d = "Problem 12.32d"
    case PROB1232e = "Problem 12.32e"
    case PROB1232f = "Problem 12.32f"
    case PROB1232g = "Problem 12.32g"
    case PROB1232h = "Problem 12.32h"
    case PROB1232i = "Problem 12.32i"
    case PROB1232j = "Problem 12.32j"
    case PROB1232k = "Problem 12.32k"
    case PROB1232l = "Problem 12.32l"
    case PROB1233a = "Problem 12.33a"
    case PROB1233b = "Problem 12.33b"
    case PROB1233c = "Problem 12.33c"
    case PROB1233d = "Problem 12.33d"
    case PROB1233e = "Problem 12.33e"
    case PROB1233f = "Problem 12.33f"
    
    static let allValues = [
        PROB1228,
        PROB1229a,
        PROB1229b,
        PROB1229c,
        PROB1229d,
        PROB1229e,
        PROB1229f,
        PROB1229g,
        PROB1230,
        PROB1231a,
        PROB1231b,
        PROB1231c,
        PROB1231d,
        PROB1231e,
        PROB1231f,
        PROB1231g,
        PROB1232a,
        PROB1232b,
        PROB1232c,
        PROB1232d,
        PROB1232e,
        PROB1232f,
        PROB1232g,
        PROB1232h,
        PROB1232i,
        PROB1232j,
        PROB1232k,
        PROB1232l,
        PROB1233a,
        PROB1233b,
        PROB1233c,
        PROB1233d,
        PROB1233e,
        PROB1233f
    ]
}

enum OneByteProblemDescriptions : String {
    case PROB1228 = "Specification to fetch the operand specifier and increment PC."
    case PROB1229a = "Specification for MOVSPA."
    case PROB1229b = "Specification for MOVFLGA."
    case PROB1229c = "Specification for MOVAFLG."
    case PROB1229d = "Specification for NOTA."
    case PROB1229e = "Specification for NEGA."
    case PROB1229f = "Specification for ROLA."
    case PROB1229g = "Specification for RORA."
    case PROB1230 = "Specification for ASLA."
    case PROB1231a = "Specification for SUBA this,i."
    case PROB1231b = "Specification for ANDA this,i."
    case PROB1231c = "Specification for ORA this,i."
    case PROB1231d = "Specification for CPWA this,i."
    case PROB1231e = "Specification for CPBA this,i."
    case PROB1231f = "Specification for LDWA this,i."
    case PROB1231g = "Specification for LDBA this,i."
    case PROB1232a = "Specification for LDWA here,d."
    case PROB1232b = "Specification for LDWA here,s."
    case PROB1232c = "Specification for LDWA here,sf."
    case PROB1232d = "Specification for LDWA here,x."
    case PROB1232e = "Specification for LDWA here,sx."
    case PROB1232f = "Specification for LDWA here,sfx."
    case PROB1232g = "Specification for STWA there,n."
    case PROB1232h = "Specification for STWA there,s."
    case PROB1232i = "Specification for STWA there,sf."
    case PROB1232j = "Specification for STWA there,x."
    case PROB1232k = "Specification for STWA there,sx."
    case PROB1232l = "Specification for STWA there,sfx."
    case PROB1233a = "Specification for BR main."
    case PROB1233b = "Specification for BR guessJT,x."
    case PROB1233c = "Specification for CALL alpha."
    case PROB1233d = "Specification for RET."
    case PROB1233e = "Specification for DECO num,i."
    case PROB1233f = "Specification for RETTR."
    
    static let allValues = [
        PROB1228,
        PROB1229a,
        PROB1229b,
        PROB1229c,
        PROB1229d,
        PROB1229e,
        PROB1229f,
        PROB1229g,
        PROB1230,
        PROB1231a,
        PROB1231b,
        PROB1231c,
        PROB1231d,
        PROB1231e,
        PROB1231f,
        PROB1231g,
        PROB1232a,
        PROB1232b,
        PROB1232c,
        PROB1232d,
        PROB1232e,
        PROB1232f,
        PROB1232g,
        PROB1232h,
        PROB1232i,
        PROB1232j,
        PROB1232k,
        PROB1232l,
        PROB1233a,
        PROB1233b,
        PROB1233c,
        PROB1233d,
        PROB1233e,
        PROB1233f
    ]
}

enum TwoByteProblems : String {
    case PROB1234a = "Problem 12.34a"
    case PROB1234b = "Problem 12.34b"
    case PROB1235a = "Problem 12.35a"
    case PROB1235b = "Problem 12.35b"
    case PROB1235c = "Problem 12.35c"
    case PROB1235d = "Problem 12.35d"
    case PROB1235e = "Problem 12.35e"
    case PROB1235f = "Problem 12.35f"
    case PROB1235g = "Problem 12.35g"
    case PROB1235h = "Problem 12.35h"
    case PROB1235i = "Problem 12.35i"
    case PROB1235j = "Problem 12.35j"
    case PROB1235k = "Problem 12.35k"
    case PROB1235l = "Problem 12.35l"
    case PROB1236a = "Problem 12.36a"
    case PROB1236b = "Problem 12.36b"
    case PROB1236c = "Problem 12.36c"
    case PROB1236d = "Problem 12.36d"
    case PROB1236e = "Problem 12.36e"
    case PROB1236f = "Problem 12.36f"
    
    static let allValues = [
        PROB1234a,
        PROB1234b,
        PROB1235a,
        PROB1235b,
        PROB1235c,
        PROB1235d,
        PROB1235e,
        PROB1235f,
        PROB1235g,
        PROB1235h,
        PROB1235i,
        PROB1235j,
        PROB1235k,
        PROB1235l,
        PROB1236a,
        PROB1236b,
        PROB1236c,
        PROB1236d,
        PROB1236e,
        PROB1236f
    ]
}

enum TwoByteProblemDescriptions : String {
    case PROB1234a = "Specification to fetch OprndSpec assuming no previous pre-fetch."
    case PROB1234b = "Specification to fetch OprndSpec assuming previous pre-fetch."
    case PROB1235a = "Specification for LDWA here,d."
    case PROB1235b = "Specification for LDWA here,s."
    case PROB1235c = "Specification for LDWA here,sf."
    case PROB1235d = "Specification for LDWA here,x."
    case PROB1235e = "Specification for LDWA here,sx."
    case PROB1235f = "Specification for LDWA here,sfx."
    case PROB1235g = "Specification for STWA there,n."
    case PROB1235h = "Specification for STWA there,s."
    case PROB1235i = "Specification for STWA there,sf."
    case PROB1235j = "Specification for STWA there,x."
    case PROB1235k = "Specification for STWA there,sx."
    case PROB1235l = "Specification for STWA there,sfx."
    case PROB1236a = "Specification for BR main."
    case PROB1236b = "Specification for BR guessJT,x."
    case PROB1236c = "Specification for CALL alpha."
    case PROB1236d = "Specification for RET."
    case PROB1236e = "Specification for DECO num,i."
    case PROB1236f = "Specification for RETTR."
    
    static let allValues = [
        PROB1234a,
        PROB1234b,
        PROB1235a,
        PROB1235b,
        PROB1235c,
        PROB1235d,
        PROB1235e,
        PROB1235f,
        PROB1235g,
        PROB1235h,
        PROB1235i,
        PROB1235j,
        PROB1235k,
        PROB1235l,
        PROB1236a,
        PROB1236b,
        PROB1236c,
        PROB1236d,
        PROB1236e,
        PROB1236f
    ]
}
