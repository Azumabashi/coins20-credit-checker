import os
import strutils
import system

type Score = enum
    APlus
    A
    B
    C
    D
    P
    F

type TwinsData = object
    id: string
    name: string
    credit: float
    score: Score
    isIncludeToGpa: bool

proc str2score(s: string): Score = 
    case s:
    of "A+":
        result = Score.APlus
    of "A":
        result = Score.A
    of "B":
        result = Score.B
    of "C":
        result = Score.C
    of "D":
        result = Score.D
    of "P":
        result = Score.P
    of "F":
        result = Score.F
    else:
        echo "ERROR: Unknown score"
        quit(1)

proc parseTwinsData(data: seq[string]): TwinsData = 
    let score = str2score(data[7])
    let isIncludeToGpa = data[8] != "C0" or score == Score.P or score == Score.F
    return TwinsData(
            id: data[2],
            name: data[3],
            credit: data[4].parseFloat,
            score: score,
            isIncludeToGpa: isIncludeToGpa
        )

proc readCsv(): seq[TwinsData] = 
    let f = open(commandLineParams()[0], FileMode.fmRead)
    defer:
        close(f)
    let _ = f.readLine()  # header を読み捨てる
    while not f.endOfFile():
        result.add(f.readLine().replace("\"").replace(" ").split(",").parseTwinsData)

proc main() = 
    let data = readCsv()
    echo data

main()