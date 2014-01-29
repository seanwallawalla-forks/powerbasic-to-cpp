# refactor.uc - uCalc Transformation file
# This file was saved with uCalc Transform 2.5 on 1/15/2014 4:44:51 PM
# Comment: This rewrites code in more proper PB form

ExternalKeywords: Exclude, Comment, Selected, ParentChild, FindMode, OutputFile, BatchAction, SEND
ExternalKeywords: Highlight, ForeColor, BackColor, FontName, FontSize, FontStyle
ExternalKeywords: FilterEndText, FilterSeparator, FilterSort, FilterSortFunc, FilterStartText, FilterUnique

FindMode: Replace

# Definitions


# Search Criteria

Criteria: 0
Enabled: True
Exclude: False
Comment: This rewrites code in more proper PB form
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
Min: 0
Max: -1
MinSoft: 0
MaxSoft: -1
BatchAction: Transform
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
Selected: True
Find: 
Replace: {@Define::
            Token: [\x27\_].* ~~ Properties: ucWhiteSpace
            Token: : ~~ Properties: ucStatementSep
         }{@Define: Var: Args As String}

Criteria: 2
Comment: Adds parenthesis around args in function/sub calls that do not have it
BackColor: Lime
Find: [Declare]{ Function|Sub } {name} [Lib {lib}] [Alias {alias}] ({args})
Replace: {@Eval:
            Args = Remove("{args}", "{ Optional|ByVal|ByRef|As {type:1} [Ptr] | {'[#!@$%&]+'} | () }")
            Args = SetSyntaxParams(Args, Args)
         }{@Define::
            {@Eval: "PassOnce ~~ Syntax: {name} "+Args+" ::= {name}("+Args+")"}
            {@Eval: "SkipOver ~~ Syntax: {name} ({etc})"}
         }{Self}

Criteria: 3
Comment: Adds closing quote for quoted text with missing closing quote
BackColor: DarkKhaki
Find: {QuotedText:"\q[^\q\n]*"}{nl}
Replace: {QuotedText}"{nl}

Criteria: 4
Find: 
Replace: 

# End Search