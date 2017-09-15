grammar edu:umn:cs:melt:exts:ableC:regex:concreteSyntax;

-- This fails to compile-- RegexBegin is in a non bridge production position.

-- marking terminal RegexMatchVerbose_t 'match' lexer classes {Ckeyword} ;
-- terminal Against_t 'against' ;

-- concrete productions top::cnc:PrimaryExpr_c
-- | 'match' e::cnc:Expr_c 'against' r::RX_c
--   { top.ast = regexMatch(e.ast, r.ast, location=top.location); }

-- nonterminal RX_c with ast<abs:Expr>, location;

-- concrete production rx_c
-- rx::RX_c ::= d1::RegexBegin_t  r::Regex_R  d2::RegexEnd_t
-- layout {}
-- { rx.ast = regexLiteralExpr("\"" ++ r.regString ++ "\"", location=d1.location);
-- }
