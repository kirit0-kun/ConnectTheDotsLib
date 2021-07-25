//
//  main.swift
//  ConnectTheDotsLib
//
//  Created by Mostafa Ibrahim on 24/07/2021.
//

import Foundation


struct Position {
    let row: Int8
    let col: Int8
}

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
        if let firstPos = getPositionFor(sideNumber: number, isVertical: v) {
            let first = getSquareFor(squarePosition: firstPos)
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

func getPositionFor(sideNumber number: Int,isVertical v: Bool) -> Position? {
    
    if (v) {
        let lastBorderRowStart = totalSides - Int(numSides) + 1;
        if (number >= lastBorderRowStart) {
            return Position(row: numSides, col: Int8(totalSquares - (totalSides - number)))
        }
        if (number <= numSides) {
            return Position(row: 1, col: Int8(number))
        }
    }
    
    // can be optimised
    let den: Int = Int(2 * numSides + 1);
    let z = Int(v ? 0 : numSides)
    var col: Int8 = 0
    let lastCol: Int8 = numSides + (v ? 0 : 1)
    var m: Int = Int(round(Double((number - z) / den)) - 1)
    
    while col <= 0 || col > lastCol {
        m += 1
        print("\(number) \(z) \(m) \(den)")
        col = Int8(number - z - m*den)
        if (m >= numSides) {
            return nil
        }
    }
    
    let nom: Int = number - Int(col) - z;
    if nom % den == 0 {
        let r = nom / den + 1;
        if (!v && col == lastCol) {
            col -= 1
        }
        return Position(row: Int8(r), col: col)
    }
    
    return nil
}

func getSquareFor(squarePosition pos: Position) -> Int {
    let square = Int(pos.row - 1) * Int(numSides) + Int(pos.col);
    return square;
}

func getPositionFor(squareNumber number: Int) -> Position? {
    if (number > totalSquares) {
        return nil
    }
    let row: Int8 = Int8(floor(Double(number) / Double(numSides)))
    let col: Int8 = Int8(number % Int(numSides)) + 1
    return Position(row: row, col: col)
}

print(getSquaresFor(sideNumber: 53))
