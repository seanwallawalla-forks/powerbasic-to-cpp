# implicit-dim.uc - uCalc Transformation file
# This file was saved with uCalc Transform 2.95 on 4/22/2014 5:46:02 PM
# Comment: Declares variables (with Dim) that were not explicitely declared before

ExternalKeywords: Exclude, Comment, Selected, ParentChild, FindMode, InputFile, OutputFile, BatchAction, SEND
ExternalKeywords: Highlight, ForeColor, BackColor, FontName, FontSize, FontStyle
ExternalKeywords: FilterEndText, FilterSeparator, FilterSort, FilterSortFunc, FilterStartText, FilterUnique, FilterTally

FindMode: Replace

# Definitions


# Search Criteria

Criteria: 0
Enabled: True
Exclude: False
Comment: Declares variables (with Dim) that were not explicitely declared before
Selected: False
Highlight: False
ForeColor: ControlText
BackColor: Aqua
FontName: 
FontSize: 
FontStyle: 
CaseSensitive: False
QuoteSensitive: True
CodeBlockSensitive: True
FilterEndText: 
FilterSeparator: {#10}
FilterSort: False
FilterSortFunc: 
FilterStartText: 
FilterUnique: False
FilterTally: False
Min: 0
Max: -1
MinSoft: 0
MaxSoft: -1
BatchAction: Transform
InputFile: ImplicitDim.Bas
OutputFile: 
SEND: 
StartAfter: 0
StopAfter: -1
SkipOver: False
ParentChild: 0
Pass: 0
PassOnce: True
Precedence: 0
RightToLeft: False

Criteria: 1
Find: 
Replace: {@Define:: 
            Token: \x27.* ~~ Properties: ucWhitespace
            Token: _[^\n]*\n ~~ Properties: ucWhitespace
         }
         {@Define:
            Var: Globals As Table
            Var: ImplicitDim As Table
            Var: ExplicitDim As Table
            Var: CurrentRoutine As String
         }

Criteria: 2
Comment: Teporarily adds Dim keyword in front of args for further parsing
Pass: 1

Criteria: 3
Find: {nl}{routine: Sub | Function } {etc}({args})
Replace: {nl}{routine} {etc}(Dim {args})

Criteria: 4
SkipOver: True
Find: {nl}Function =
Replace: [Skip over]

Criteria: 5
Comment: Inserts explicitly Dimmed variable names in global or local tables
Pass: 2

Criteria: 6
Find: Global {variable:1}
Replace: {Self}{@Eval: Insert(Globals, "{variable}")}

Criteria: 7
BackColor: Silver
Find: {nl}{ Macro | Type | Union | % | $ | Declare {func:1} }  {name:1}
Replace: {Self}{@Eval: Insert(Globals, "{name}")}

Criteria: 8
BackColor: Lime
Find: {nl}{ Sub | Function }{" +"}{RoutineName:"[a-z0-9_]+"}
Replace: {Self}{@Define:
            Var: {RoutineName}ExplicitDim As Table
            Var: {RoutineName}ImplicitDim As Table
         }{@Eval: SetVar(CurrentRoutine, "{RoutineName}"); Insert(Globals,"{RoutineName}")}

Criteria: 9
Find: {nl}End { Sub | Function }
Replace: {Self}{@Eval: SetVar(CurrentRoutine, "")}

Criteria: 10
Selected: True
BackColor: Pink
Find: {declare: Dim [[Optional] { ByVal | ByRef }] | Local | Static | Register | fstream } {variable:1}
Replace: {Self}{@Eval: Insert(~Eval(CurrentRoutine)ExplicitDim, "{variable}")}

Criteria: 11
Comment: Temporarily inserts declaration for each individual variable a lines with a list of multiple vars, for easier parsing
BackColor: SlateBlue
PassOnce: False
Find: {declare: Global|Dim|Local|Static|Register} {variable},
Replace: {declare} {variable} ::: {declare}

Criteria: 12
Comment: Places non-Dimmed variable names in separate local tables
Pass: 3

Criteria: 13
Find: {variable:"[a-z][a-z0-9_]*"}
Replace: {Self}{@Eval: 
            IIf(Handle(Globals, "{variable}")==0 And Handle(~Eval(CurrentRoutine)ExplicitDim, "{variable}")==0,
                Insert(~Eval(CurrentRoutine)ImplicitDim, "{variable}"); "")
         }

Criteria: 14
SkipOver: True
Find: {"[a-z0-9_]+"} { {UDT:"\.[a-z0-9_\@\.]+"} | {Func:"\("} }
Replace: [Skip over]

Criteria: 15
SkipOver: True
Find: {@Eval: "{'"+Retain(FileText("PBKeywords.txt"), "{keyword:'[a-z0-9_]+'}", Delim("\b|"))+"\b'}"}
Replace: [Skip over]

Criteria: 16
BackColor: Brown
Find: {"\n"}{ Sub | Function }{" +"}{RoutineName:"[a-z0-9_]+"}
Replace: {Self}{@Eval: SetVar(CurrentRoutine, "{RoutineName}")}

Criteria: 17
Find: {"\n"}End { Sub | Function }
Replace: {Self}{@Eval: SetVar(CurrentRoutine, "")}

Criteria: 18
Comment: Inserts local Dim statements for variables that were not dimmed
Pass: 4

Criteria: 19
BackColor: Purple
Find: {nl}{ Sub | Function }{" +"}{RoutineName:"[a-z0-9_]+"} {etc}
Replace: {Self}
         {@Eval: 
            text = ""
            uc_For(x, 1, Count({RoutineName}ImplicitDim), 1,
               text += "   Dim "
               text += ReadKey({RoutineName}ImplicitDim, x)
               text += " ' Implicit"+Chr(10)
            );
            text
         }

Criteria: 20
Comment: Clean up (temp declaration statements removed)
Pass: 5

Criteria: 21
BackColor: Violet
Find: ::: {declare:1}
Replace: ,

Criteria: 22
BackColor: CornflowerBlue
Find: (Dim {args})
Replace: ({@Eval: Replace("{args}", "::: Dim", ",")})

Criteria: 23
Find: Dim {nl}
Replace: {Nothing}

# End Search