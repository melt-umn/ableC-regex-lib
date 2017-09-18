grammar edu:umn:cs:melt:exts:ableC:regex:concretesyntax;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;
imports edu:umn:cs:melt:ableC:abstractsyntax as abs;
imports silver:langutil only ast;

imports edu:umn:cs:melt:exts:ableC:regex;

marking terminal RegexBegin_t '/';
terminal RegexEnd_t '/';

concrete production regex_c
e::cnc:PrimaryExpr_c ::= d1::RegexBegin_t  r::Regex_R  d2::RegexEnd_t
layout {}
{
  e.ast = regexLiteralExpr("\"" ++ r.regString ++ "\"", location=e.location);
}


