type Score = enum
    APlus
    A
    B
    C
    D
    P
    F
    Taking
export Score

type TwinsData = object
    id*: string
    name*: string
    credit*: float
    score*: Score
    isIncludeToGpa*: bool
export TwinsData

type MatchType = enum
    CourseCode
    CourseName
export MatchType

type CourseType = enum 
    SpecialtyRequired
    SpecialtyElective
    SpecialtyBasicRequired
    SpecialtyBasicElective
    CommonRequired
    CommonElective
    OtherRequired
    OtherElective
export CourseType

type CreditSum = object
    max*: int
    min*: int
export CreditSum

type SubjectType = object
    index*: seq[int]
    required*: CreditSum
    achieved*: int
export SubjectType

type CreditCondition = object
    title*: string
    cond*: string
    required*: int
    matchType*: MatchType
    courseType*: CourseType
export CreditCondition
