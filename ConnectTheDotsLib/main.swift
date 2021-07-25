//
//  main.swift
//  ConnectTheDotsLib
//
//  Created by Mostafa Ibrahim on 24/07/2021.
//

import Foundation

let top = "-"
let left = "|"

class Square {
    let number: Int
    var borders: Int8
    var owner: Character?
    
    init(number: Int, borders: Int8, owner: Character?) {
        self.number = number
        self.borders = borders
        self.owner = owner
    }
}

struct Position {
    let row: Int8
    let col: Int8
}

let numSides: Int8 = 5 //n
let numSideDots: Int8 = numSides + 1 //l

let totalSquares: Int = Int(pow(Double(numSides), 2)) //c
let totalDots: Int = Int(pow(Double(numSideDots), 2)) //p
let totalSides: Int = 2 * Int(numSideDots) * Int(numSideDots - 1) //b

let squares: [Square] = {
    var result: [Square] = []
    for i in 1...totalSquares {
        result.append(Square(number: i, borders: 0, owner: nil))
    }
    return result
}();

var sides: [Bool] = Array(repeating: false, count: totalSides);

let players: [Character] = ["X", "O"]

func getSquaresFor(sideNumber number: Int) -> [Square] {
    var result: [Int] = []
    
    var v = true
    for _ in 1...2 {
        if let firstPos = getBarePositionFor(sideNumber: number, isVertical: v) {
            let first = getSquareNumberFor(squarePosition: firstPos)
            if v {
                if first <= numSides || first > (totalSquares - Int(numSides)) {
                    result.append(first)
                } else {
                    let second = first - Int(numSides)
                    result.append(first)
                    result.append(second)
                }
            } else {
                let lastCol: Int8 = numSides + 1
                if firstPos.col == lastCol {
                    let pos = normalizePosition(firstPos, v)
                    let posNum = getSquareNumberFor(squarePosition: pos)
                    result.append(posNum)
                } else if (first-1) % Int(numSides) == 0 {
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
    return result.map({ squares[$0-1] })
}

func getPositionFor(sideNumber number: Int,isVertical v: Bool) -> Position? {
    guard let position = getBarePositionFor(sideNumber: number, isVertical: v) else {
        return nil
    }
    return normalizePosition(position, v)
}

func normalizePosition(_ position: Position,_ vertical: Bool) -> Position {
    let lastCol: Int8 = numSides + (vertical ? 0 : 1)
    var col = position.col
    if (!vertical && col == lastCol) {
        col -= 1
    }
    return Position(row: position.row, col: col)
}

func getBarePositionFor(sideNumber number: Int,isVertical v: Bool) -> Position? {
    
    if (v) {
        let lastBorderRowStart = totalSides - Int(numSides) + 1;
        if (number >= lastBorderRowStart) {
            return Position(row: numSides, col: Int8(numSides - Int8(totalSides - number)))
        }
        if (number <= numSides) {
            return Position(row: 1, col: Int8(number))
        }
    }
    
    let lastCol: Int8 = numSides + (v ? 0 : 1)
    
    // can be optimised
    let den: Int = Int(2 * numSides + 1);
    let z = Int(v ? 0 : numSides)
    let m: Int = Int(round(Double((number - z) / den)))
    let col: Int8 = Int8(number - z - m*den)
    //print("\(number) \(z) \(m) \(den) \(col)")
    if (m >= numSides || col > lastCol || col <= 0) {
        return nil
    }
    let r = m + 1;
    return Position(row: Int8(r), col: col)
}

func getSquareNumberFor(squarePosition pos: Position) -> Int {
    let square = Int(pos.row - 1) * Int(numSides) + Int(pos.col);
    return square;
}

func getPositionFor(squareNumber number: Int) -> Position? {
    if (number > totalSquares) {
        return nil
    }
    let row: Int8 = Int8(floor(Double(number) / Double(numSides))) + 1
    let col: Int8 = Int8(number % Int(numSides))
    return Position(row: col == 0 ? (row - 1) : row, col: col == 0 ? numSides : col)
}

func getSidesFor(squareNum number: Int) -> [Int] {
    guard let position = getPositionFor(squareNumber: number) else {
        return []
    }
    return getSidesFor(position: position)
}

func getSidesFor(position p: Position) -> [Int] {
    let top = Int(numSides) * Int(p.row-1) + Int(numSideDots) * Int(p.row-1) + Int(p.col)
    let down = Int(numSides) * Int(p.row) + Int(numSideDots) * Int(p.row) + Int(p.col)
    let left = top + Int(numSides)
    let right = left + 1
    return [top, right, down, left]
}

func drawSide(_ number: Int, _ player: Character) -> Square? {
    let side = sides[number-1]
    if (!side) {
        sides[number-1] = true
        let boxes = getSquaresFor(sideNumber: number)
        boxes.forEach({
            $0.borders += 1
            if ($0.borders >= 4) {
                $0.owner = player
            }
            print("\($0.number) \($0.borders) \($0.owner)")
        })
    }
    return nil
}

func printBoard() -> String {
    var board: String = ""
    var start: Int = 1
    for i in 1...(numSides*2+1) {
        var row: String = ""
        let isV = i % 2 == 1
        let end = start + Int(numSides)
        for b in start..<end {
            let side = sides[b - 1]
            if (isV) {
                row.append(".")
                if (side) {
                    row.append(top)
                } else {
                    row.append(" ")
                }
            } else {
                let box: Square = getSquaresFor(sideNumber: b).last!
                if (side) {
                    row.append(left)
                } else {
                    row.append(" ")
                }
                if (box.owner != nil) {
                    row.append(String(describing: box.owner!))
                } else {
                    row.append(" ")
                }
            }
        }
        if (isV) {
            row.append(".")
        } else {
            let side = sides[end-1]
            if (side) {
                row.append(left)
            } else {
                row.append(" ")
            }
        }
        print(row)
        board.append(row)
        board.append("\n")
        start = end + Int(isV ? 0 : 1)
    }
    return board
}

//for i in 1...totalSides {
//    print("\(i) \(getSquaresFor(sideNumber: i))")
//}
//
//for i in 1...totalSquares {
//    print("\(i) \(getSidesFor(squareNum: i))")
//}
drawSide(1, "X")
drawSide(6, "X")
drawSide(7, "X")
drawSide(12, "X")
drawSide(11, "X")
printBoard()
