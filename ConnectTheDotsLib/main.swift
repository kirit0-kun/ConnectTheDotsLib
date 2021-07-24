//
//  main.swift
//  ConnectTheDotsLib
//
//  Created by Mostafa Ibrahim on 24/07/2021.
//

import Foundation

let numSides: Int8 = 5 //n

let numSideDots = 5 + 1 //l
let totalSquares: Int = Int(pow(Double(numSides), 2)) //c

let totalDots = pow(Double(numSideDots), 2) //p
let totalSides = 2 * numSideDots * (numSideDots - 1) //b

let squares: [Character?] = Array(repeating: nil, count: totalSquares);

let sides: [Bool] = Array(repeating: false, count: totalSides);

let players: [Character] = ["X", "O"]

func getSquaresFor(sideNumber number: Int) -> [Int] {
    var result: [Int] = []
    
    var v = true
    for _ in 1...2 {
        if let first = getSquareFor(sideNumber: number, isVertical: v) {
            if v {
                if first <= numSides || first > (totalSquares - Int(numSides)) {
                    result.append(first)
                } else {
                    let second = first - Int(numSides)
                    result.append(first)
                    result.append(second)
                }
            } else {
                if (first-1) % Int(numSides) == 0 || first % Int(numSides) == 0 {
                    result.append(first)
                } else {
                    // two squares
                    let second = first - 1
                    result.append(first)
                    result.append(second)
                }
            }
            break
        }
        v = !v;
    }
    result.sort()
    return result
}

func getSquareFor(sideNumber number: Int,isVertical v: Bool) -> Int? {
    
    if (v) {
        let lastBorderRowStart = totalSides - Int(numSides) + 1;
        if (number >= lastBorderRowStart) {
            return totalSquares - (totalSides - number)
        }
        if (number <= numSides) {
            return number
        }
    }
    
    let den: Int = Int(2 * numSides + 1);
    let z = Int(v ? 0 : numSides)
    let firstCol: Int8 = max(Int8(den - number + z), 1)
    let lastCol: Int8 = numSides + (v ? 0 : 1)
    
    // possibly not needed
    for o in firstCol...lastCol {
        let nom: Int = number - Int(o) - z;
        if nom % den == 0 {
            let r = nom / den + 1;
            var col = o
            if (!v && o == lastCol) {
                col -= 1
            }
            let square = (r - 1) * Int(numSides) + Int(col);
            return square;
        }
    }
    
    return nil
}

print(getSquaresFor(sideNumber: 53))
