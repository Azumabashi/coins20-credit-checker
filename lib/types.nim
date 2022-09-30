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
    max*: float
    min*: float
export CreditSum

type SubjectType = object
    index*: seq[int]
    required*: CreditSum
    achieved*: float
    courseType*: CourseType
export SubjectType

type CreditCondition = object
    title*: string
    cond*: string
    required*: float
    matchType*: MatchType
    courseType*: CourseType
    acquired*: bool
    index*: seq[int]
export CreditCondition
