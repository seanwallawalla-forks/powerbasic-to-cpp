# implicit-convert.uc - uCalc Transformation file
# This file was saved with uCalc Transform 2.96 on 5/29/2014 4:02:47 PM
# Comment: Handles implicit data type conversions

ExternalKeywords: Exclude, Comment, Selected, ParentChild, FindMode, InputFile, OutputFile, BatchAction, SEND
ExternalKeywords: Highlight, ForeColor, BackColor, FontName, FontSize, FontStyle
ExternalKeywords: FilterEndText, FilterSeparator, FilterSort, FilterSortFunc, FilterStartText, FilterUnique, FilterTally

FindMode: Replace

# Definitions


# Search Criteria

Criteria: 0
Enabled: False
Exclude: False
Comment: Handles implicit data type conversions
Selected: False
Highlight: True
ForeColor: ControlText
BackColor: Aqua
FontName: 
FontSize: 
FontStyle: 
CaseSensitive: False
QuoteSensitive: False
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
InputFile: 
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
Enabled: True
Highlight: False
Find: 
Replace: {@Eval:
            Dim Size As Table = {
               "Byte", 1, "Word", 2, "Integer", 2, "Long", 4, "Dword", 4,
               "Single", 4, "Double", 8, "Extended", 10
            }
         }
         {@Define:
            Var: Def As String
            Var: Args As String
            Var: Before As String
            Var: After As String
            Var: UDT As Table
            Var: Size
            Var: Final
            Var: Variables As Table
            SyntaxArgL: {number} = {number:"([0-9]*\.)?[0-9]+(e[-+]?[0-9]+)?"}
         }
         {@Define:: Token: _.*\n ~~ Properties: ucWhitespace }

Criteria: 2
Comment: Inserts data type names in front of variabls and functions
Pass: 1

Criteria: 3
Enabled: True
Highlight: False
Find: {nl}[Declare] { Function | Sub } {name~:1} [Alias {alias}] ([{args%}]) [As {ftype:1=void}]
Replace: {@Exec:
            Args = Remove("{args}", "{ Optional | ByVal | Ptr | () | {' *_.*\n *'} }")
            Before = Replace(Args, "[ByRef] {arg:1} As {type:1}", "{{arg}%}")
            After = Replace(Args, "ByRef {arg:1} As {type:1}", "ByRef({arg} As {type})")
            After = Replace(After, "{arg:1} As {type:1}", "##{type}({{arg}})")
         
            Def  = "Pass: 1 ~~ Syntax: {name}("+Before+")"
            Def += " ::= `{ftype}({name}(" + After + "))"
         }{@Define:: {@Eval: Def}}{Self}

Criteria: 4
Enabled: True
Highlight: False
Find: { Global | Local | Static | Dim | , | { ByVal | ByRef } } {var:1}[([{size}])] As {type:1}
Replace: {Self}{@Execute: Insert(Variables, {var})
         }{@Define:: Pass: 1 ~~ Syntax: {var} ::= `{type}({var})
         }{@Define:: Pass: 1 ~~ Syntax: {var}([{i%}]) ::= `{type}({var}({i}))}

Criteria: 5
Enabled: True
Highlight: False
Find: {number}
Replace: {@Eval: IIf(Int({number})=={number}, "`Long({number})", "`Extended({number})")}

Criteria: 6
Enabled: True
Highlight: False
BackColor: RoyalBlue
Find: {q}{text}{q}
Replace: `StringLit({Self})

Criteria: 7
Enabled: True
Highlight: False
BackColor: Pink
Find: {func: Asc|InStr|Len|UBound|VarPtr|StrPtr|Ceil|Int } ({args%})
Replace: `Long({func}({args}))

Criteria: 8
Enabled: True
Find: {func: Sin|Cos|Tan|Atn|Exp|Exp2|Exp10|Log|Log2|Log10|Abs } ({args%})
Replace: `Extended({func}({args}))

Criteria: 9
Enabled: True
Highlight: False
BackColor: SlateBlue
Find: {func:
         Mid|Left|Right|Remove|Extract|Space|Hex|Oct|Bin|Dir|Min|Max|
         Remain|UCase|LCase|Trim|LTrim|RTrim|Choose|Repeat|Dir|CurDir
      }$({args%})
Replace: `String({func}$({args}))

Criteria: 10
Enabled: True
Find: {nl}${equate:1}
Replace: {Self}{@Define:: Pass: 1 ~~ Syntax: ${equate} ::= `String(${equate})}

Criteria: 11
Enabled: True
Find: {nl}$${equate:1}
Replace: {Self}{@Define:: Pass: 1 ~~ Syntax: $${equate} ::= `WString($${equate})}

Criteria: 12
Enabled: True
Find: {nl}%{equate:1}
Replace: {Self}{@Define:: Pass: 1 ~~ Syntax: %{equate} ::= `Long(%{equate})}

Criteria: 13
Enabled: True
Highlight: False
BackColor: Purple
SkipOver: True
Find: {nl} { Type | Union }
         {members+}
      End {TypeOrUnion}
Replace: [Skip over]

Criteria: 14
Enabled: True
BackColor: Khaki
SkipOver: True
Find: {nl}{ # | ! | ASM } {etc} {@Note: Skips metastatements, ASM}
Replace: [Skip over]

Criteria: 15
Enabled: True
SkipOver: True
Find: ' {Comment:".*"}
Replace: [Skip over]

Criteria: 16
Comment: Convert
Pass: 2

Criteria: 17
Enabled: True
BackColor: Violet
PassOnce: False
Find: ##Asciiz(string({arg}))
Replace: `Asciiz({arg}.c_str())

Criteria: 18
Enabled: True
Find: `StringLit({arg})
Replace: `String({arg})

Criteria: 19
Enabled: True
PassOnce: False
Find: `StringLit({arg})+`StringLit({arg})
Replace: `String(string({arg})+{arg})

Criteria: 20
Enabled: True
BackColor: CornflowerBlue
PassOnce: False
Find: `WString({arg}) + `String({arg})
Replace: `WString({arg}) + `WString(string({arg}))

Criteria: 21
Enabled: True
Find: Len({other})
Replace: sizeof({other})

Criteria: 22
Enabled: True
BackColor: SandyBrown
PassOnce: False
Find: Len(`String({arg}))
Replace: string({arg}).length()

Criteria: 23
Enabled: True
BackColor: Gold
PassOnce: False
Find: Len(`LPCSTR({arg}))
Replace: `Long(strlen({arg}))

Criteria: 24
Enabled: True
PassOnce: False
Find: `{ Extended | Ext }
Replace: `Double

Criteria: 25
Enabled: True
SkipOver: True
Find: ' {Comment:".*"}
Replace: [Skip over]

Criteria: 26
Comment: Highlights the inserted data type names
Pass: 3

Criteria: 27
Enabled: True
Find: {@Start}
      {@Note:
         The use of Final is due to a limitation where immediate expansion in
         {arg%} expands all passes causing the undesirable change in pass 3
         before it is needed.
      }
Replace: {@Exec: Final = True}

Criteria: 28
Enabled: True
PassOnce: False
Find: ByRef(##{RequiredType}({arg}))  {@If: Final}
Replace: lvalue({RequiredType}({arg}))

Criteria: 29
Enabled: True
Selected: True
PassOnce: False
Find: ByRef(##{RequiredType}(`{ActualType}({scalar:1}[()])))
      {@If: Final == True And Index(Variables, {scalar}) <> 0}
Replace: {scalar}

Criteria: 30
Enabled: True
PassOnce: False
Find: ByRef(##{RequiredType}(`{ActualType}({array:1}({index}))))
      {@If: Final == True And Index(Variables, {array}) <> 0}
Replace: {array}({index})

Criteria: 31
Enabled: True
PassOnce: False
Find: { ` | ## }{type:1}({arg}) {@If: Final}
Replace: {arg}

Criteria: 32
Enabled: False
BackColor: Red
Find: ##{type:1}
Replace: {Self}

Criteria: 33
Enabled: False
Comment: This line is there to provide highlighting for clarity
Find: `{type:1}
Replace: {Self}

# End Search
