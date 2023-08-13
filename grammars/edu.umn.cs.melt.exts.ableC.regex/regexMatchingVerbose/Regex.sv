grammar edu:umn:cs:melt:exts:ableC:regex:regexMatchingVerbose;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;
imports edu:umn:cs:melt:ableC:abstractsyntax:host as abs;
imports silver:langutil only ast;

import edu:umn:cs:melt:exts:ableC:regex;

-- Spurious import, to trigger the tests on build.
import edu:umn:cs:melt:exts:ableC:regex:mda_test;

marking terminal RegexMatch_t 'match' lexer classes {cnc:Keyword, cnc:Global};
terminal Against_t 'against' lexer classes {cnc:Keyword};

concrete productions top::cnc:PrimaryExpr_c
| 'match' e::cnc:Expr_c 'against' r::RX_c
  { top.ast = regexMatch(e.ast, r.ast); }

nonterminal RX_c with ast<abs:Expr>, location;

concrete production rx_c
rx::RX_c ::= d1::RegexBegin_t  r::Regex_R  d2::RegexEnd_t
layout {}
{ rx.ast = regexLiteralExpr("\"" ++ r.regString ++ "\"");
}
