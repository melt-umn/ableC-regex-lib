grammar edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;
imports edu:umn:cs:melt:ableC:abstractsyntax:host as abs;
imports silver:langutil;
imports silver:regex:concrete_syntax;

import edu:umn:cs:melt:exts:ableC:regex;

-- Spurious import, to trigger the tests on build.
import edu:umn:cs:melt:exts:ableC:regex:mda_test;

marking terminal RegexMatch_t 'match' lexer classes {cnc:Keyword, cnc:Global};
terminal Against_t 'against' lexer classes {cnc:Keyword};

concrete productions top::cnc:PrimaryExpr_c
| 'match' e::cnc:Expr_c 'against' r::RX_c
  { top.ast = regexMatch(e.ast, r.ast, location=top.location); }

nonterminal RX_c with ast<abs:Expr>, location;

concrete production rx_c
rx::RX_c ::= RegexBegin_t  r::Regex  RegexEnd_t
layout {}
{ rx.ast = regexLiteralExpr("\"" ++ r.unparse ++ "\"", location=rx.location);
}
