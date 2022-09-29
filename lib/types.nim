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

type CourseType = enum 
    SpecialtyRequired
    SpecialtyElective
    SpecialtyBasicRequired
    SpecialtyBasicElective
    CommonRequired
    CommonElective
    OtherRequired
    OtherElective

type CreditSum = object
    max: int
    min: int

type SubjectType = object
    index: seq[int]
    required: int
    achieved: int

type CreditCondition = object
    title: string
    cond: string
    required: int
    matchType: MatchType
