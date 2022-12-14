import types
import strutils
import os
import terminal
import strformat
import sequtils

proc isRequired(courseType: CourseType): bool = 
    case courseType
    of CourseType.SpecialtyRequired, CourseType.SpecialtyBasicRequired, CourseType.CommonRequired, CourseType.OtherRequired:
        result = true
    else:
        result = false
export isRequired

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
    of "P", "認":
        result = Score.P
    of "F":
        result = Score.F
    of "履修中":
        result = Score.Taking
    else:
        echo "ERROR: Unknown score"
        quit(1)
export str2score

proc parseTwinsData(data: seq[string]): TwinsData = 
    let score = str2score(data[7])
    let isIncludeToGpa = data[8] != "C0" and score != Score.P and score != Score.F and score != Score.Taking
    return TwinsData(
            id: data[2],
            name: data[3],
            credit: data[4].parseFloat,
            score: score,
            isIncludeToGpa: isIncludeToGpa
        )
export parseTwinsData

proc readCsv(): seq[TwinsData] = 
    let f = open(commandLineParams()[0], FileMode.fmRead)
    defer:
        close(f)
    let _ = f.readLine()  # header を読み捨てる
    while not f.endOfFile():
        result.add(f.readLine().replace("\"").replace(" ").split(",").parseTwinsData)
export readCsv

proc pass(content: string) = 
    setBackgroundColor(stdout, bgGreen)
    setForegroundColor(stdout, fgBlack)
    stdout.write("PASS")
    resetAttributes(stdout)
    setForegroundColor(stdout, fgGreen)
    echo fmt" {content}"
    resetAttributes(stdout)
export pass

proc fail(content: string) = 
    setBackgroundColor(stdout, bgRed)
    stdout.write("FAIL")
    resetAttributes(stdout)
    setForegroundColor(stdout, fgRed)
    echo fmt" {content}"
    resetAttributes(stdout)
export fail

proc taking(content: string) = 
    setBackgroundColor(stdout, bgCyan)
    setForegroundColor(stdout, fgWhite)
    stdout.write("TAKING")
    resetAttributes(stdout)
    setForegroundColor(stdout, fgCyan)
    echo fmt" {content}"
    resetAttributes(stdout)
export taking

proc isTaken(score: Score): bool = 
    result = score != Score.D and score != Score.Taking
export isTaken

proc courseType2str(courseType: CourseType): string = 
    case courseType:
    of SpecialtyRequired:
        result = "専門・必修"
    of SpecialtyElective:
        result = "専門・選択必修"
    of SpecialtyBasicRequired:
        result = "専門基礎・必修"
    of SpecialtyBasicElective:
        result = "専門基礎・選択"
    of CommonRequired:
        result = "共通・必修"
    of CommonElective:
        result = "共通・選択"
    of OtherRequired:
        result = "関連・必修"
    of OtherElective:
        result = "関連・選択"
export courseType2str

proc indent(n: int) = 
    for _ in 0..<n:
        stdout.write("    ")
export indent

proc allTaken(arr: seq[bool]): bool = 
    return arr.all(proc (x: bool):bool = x)
export allTaken

proc getGp(score: Score): float = 
    case score
    of Score.APlus:
        result = 4.3
    of Score.A:
        result = 4.0
    of Score.B:
        result = 3.0
    of Score.C:
        result = 2.0
    else:
        result = 0.0

proc calculateGPA(data: seq[TwinsData]): float = 
    var
        creditSum: float = 0
        gpSum: float = 0
    for d in data:
        if d.isIncludeToGpa:
            creditSum += d.credit
            gpSum += getGp(d.score) * d.credit
    result = gpSum / creditSum
export calculateGPA