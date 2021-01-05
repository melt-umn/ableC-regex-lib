grammar edu:umn:cs:melt:exts:ableC:regex:regexLiterals;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;
imports silver:langutil;
exports silver:regex:concrete_syntax;

import edu:umn:cs:melt:exts:ableC:regex;

-- Spurious import, to trigger the tests on build.
import edu:umn:cs:melt:exts:ableC:regex:mda_test;

-- 'Operator' is maybe the closest designation for these? IDK.
marking terminal RegexBegin_t '/' lexer classes cnc:Operator;
terminal RegexEnd_t '/' lexer classes cnc:Operator;

disambiguate RegexChar_t, RegexEnd_t
{
  pluck RegexEnd_t;
}

concrete production regex_c
e::cnc:PrimaryExpr_c ::= RegexBegin_t  r::Regex  RegexEnd_t
layout {}
{
  e.ast = regexLiteralExpr("\"" ++ r.unparse ++ "\"", location=e.location);
}


