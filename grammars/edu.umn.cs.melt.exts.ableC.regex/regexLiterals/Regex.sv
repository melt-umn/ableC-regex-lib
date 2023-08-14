grammar edu:umn:cs:melt:exts:ableC:regex:regexLiterals;

imports edu:umn:cs:melt:ableC:concretesyntax as cnc;
imports silver:regex:concrete_syntax;
imports silver:langutil;

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
e::cnc:PrimaryExpr_c ::= d1::RegexBegin_t  r::Regex  d2::RegexEnd_t
layout {}
{
  e.ast = regexLiteralExpr("\"" ++ r.unparse ++ "\"");
}


