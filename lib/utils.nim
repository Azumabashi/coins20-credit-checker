import types
import strutils
import os
import terminal
import strformat

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
    of "P":
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
    let isIncludeToGpa = data[8] != "C0" or score == Score.P or score == Score.F or score == Score.Taking
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