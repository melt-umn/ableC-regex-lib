grammar edu:umn:cs:melt:exts:ableC:regex:concretesyntax;

marking terminal RegexMatchVerbose_t 'match' lexer classes {Ckeyword} ;
terminal Against_t 'against' ;

terminal VerboseStart_t '/';
terminal VerboseEnd_t '/';

-- This usage of against fails MDA
concrete productions top::cnc:PrimaryExpr_c
| 'match' e::cnc:Expr_c 'against' r::RX_c
  { top.ast = regexMatch(e.ast, r.ast, location=top.location); }

nonterminal RX_c with ast<abs:Expr>, location;

concrete production rx_c
rx::RX_c ::= d1::VerboseStart_t  r::Regex_R  d2::VerboseEnd_t
layout {}
{ rx.ast = regexLiteralExpr("\"" ++ r.regString ++ "\"", location=d1.location);
}
