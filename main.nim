import os
import strutils
import system
import std/re

type Score = enum
    APlus
    A
    B
    C
    D
    P
    F
    Taking

type TwinsData = object
    id: string
    name: string
    credit: float
    score: Score
    isIncludeToGpa: bool

type MatchType = enum
    CourseCode
    CourseName

type CreditCondition = object
    title: string
    cond: string
    required: int
    matchType: MatchType

const creditConditions: seq[CreditCondition] = @[
    CreditCondition(
        title: "主専攻実験A",
        cond: "(ソフトウェアサイエンス|情報システム|知能情報メディア)実験A",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "主専攻実験B",
        cond: "(ソフトウェアサイエンス|情報システム|知能情報メディア)実験B",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "卒業研究A",
        cond: "卒業研究A",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "卒業研究B",
        cond: "卒業研究B",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "専門語学A",
        cond: "専門語学A",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "専門語学B",
        cond: "専門語学B",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "GBx0",
        cond: "GB(2|3|4)0\\d{3}",
        required: 18,
        matchType: MatchType.CourseCode
    ),
    CreditCondition(
        title: "GB(2|3|4)",
        cond: "GB(2|3|4)[1-9]\\d{3}",
        required: 0,
        matchType: MatchType.CourseCode
    ),
    CreditCondition(
        title: "情報特別演習",
        cond: "(情報科学特別演習|情報特別演習I|情報特別演習II)",
        required: 0,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "線形代数A",
        cond: "線形代数A",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "線形代数B",
        cond: "線形代数B",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "微分積分A",
        cond: "微分積分A",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "微分積分B",
        cond: "微分積分B",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "情報数学A",
        cond: "情報数学A",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "専門英語基礎",
        cond: "専門英語基礎",
        required: 1,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "プログラミング入門",
        cond: "プログラミング入門",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "コンピュータとプログラミング",
        cond: "コンピュータとプログラミング",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "データ構造とアルゴリズム",
        cond: "データ構造とアルゴリズム",
        required: 3,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "データ構造とアルゴリズム実験",
        cond: "データ構造とアルゴリズム実験",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "論理回路",
        cond: "論理回路",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "論理回路演習",
        cond: "論理回路演習",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "確率・統計等",
        cond: "(確率論|統計学|数値計算法|論理と形式化|電磁気学|論理システム|論理システム演習)",
        required: 10,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "Computer Science in English",
        cond: "Computer Science in English (A|B)",
        required: 2,
        matchType: MatchType.CourseName
    ),
    CreditCondition(
        title: "GB1",
        cond: "GB1\\d{4}",
        required: 0,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "GA1",
        cond: "GA1\\d{4}",
        required: 8,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "フレッシュマン・セミナー",
        cond: "フレッシュマン・セミナー",
        required: 1,
        matchType: MatchType. CourseName
    ),
    CreditCondition(
        title: "学問への誘い",
        cond: "学問への誘い",
        required: 1,
        matchType: MatchType. CourseName
    ),
    CreditCondition(
        title: "体育",
        cond: "2\\d{6}",
        required: 2,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "英語",
        cond: "31[HJKL]\\d{4}",
        required: 4,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "情報",
        cond: "6\\d{6}",
        required: 4,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "総合科目（学士基盤）",
        cond: "12\\d{5}",
        required: 1,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "体育・外国語・国語・芸術",
        cond: "\\d{7}",
        required: 0,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "文系科目",
        cond: "[A|B|C|D|V|W|Y].{6}",
        required: 6,
        matchType: MatchType. CourseCode
    ),
    CreditCondition(
        title: "理系科目",
        cond: "(E.{6}|F.{6}|GB\\d{5}|GC\\d{5}|H.{6})",
        required: 0,
        matchType: MatchType. CourseCode
    ),
]

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

proc readCsv(): seq[TwinsData] = 
    let f = open(commandLineParams()[0], FileMode.fmRead)
    defer:
        close(f)
    let _ = f.readLine()  # header を読み捨てる
    while not f.endOfFile():
        result.add(f.readLine().replace("\"").replace(" ").split(",").parseTwinsData)

proc main() = 
    let data = readCsv()
    for d in data:
        for condition in creditConditions:
            case condition.matchType:
            of MatchType.CourseName:
                if condition.cond == d.name:
                    # echo "matched!"
                    break
            of MatchType.CourseCode:
                if match(d.id, re(condition.cond)):
                    break
        echo d.id, d.name, " unmatched"
main()