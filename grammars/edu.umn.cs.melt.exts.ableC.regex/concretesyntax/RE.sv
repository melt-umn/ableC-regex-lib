grammar edu:umn:cs:melt:exts:ableC:regex:concretesyntax;


synthesized attribute regString :: String;

lexer class REGEX_OPER;
lexer class REGEX_ESC submits to REGEX_OPER;

terminal Plus_t          '+' lexer classes { REGEX_OPER };
terminal Kleene_t        '*' lexer classes { REGEX_OPER };
terminal Optional_t      '?' lexer classes { REGEX_OPER };
terminal Choice_t        '|' lexer classes { REGEX_OPER };
terminal Range_t         '-' lexer classes { REGEX_OPER };
terminal RegexNot_t      '^' lexer classes { REGEX_OPER };
terminal RegexLBrack_t   '[' lexer classes { REGEX_OPER };
terminal RegexRBrack_t   ']' lexer classes { REGEX_OPER };
terminal RegexLParen_t   '(' lexer classes { REGEX_OPER };
terminal RegexRParen_t   ')' lexer classes { REGEX_OPER };
terminal RegexWildcard_t '.' lexer classes { REGEX_OPER };

terminal RegexChar_t     /./ lexer classes { REGEX_ESC }, submits to { cnc:Divide_t };


terminal EscapedChar_t /\\./ submits to { REGEX_ESC };

nonterminal Regex_R with regString;       -- full regex, removes choice |
nonterminal Regex_DR with regString;      -- concat possibly with * + or ?
nonterminal Regex_UR with regString;      -- characters or sequences/sets
nonterminal Regex_RR with regString;      -- back up to dr or nothing
nonterminal Regex_G with regString;       -- Inside charset
nonterminal Regex_RG with regString;      -- back to g or nothing
nonterminal Regex_UG with regString;      -- char or range
nonterminal Regex_CHAR with regString;


abstract production literalRegex
r::Regex_R ::= s::String
{
  r.regString = regexPurifyString(s);
}

function regexPurifyString
String ::= s::String
{
  local attribute ch :: String;
  ch = substring(0, 1, s);

  local attribute rest :: String;
  rest = substring(1, length(s), s);

  return if length(s) == 0 
	 then ""
	 else if isAlpha(ch) || isDigit(ch)
	      then ch ++ regexPurifyString(rest)
	      else "[\\" ++ ch ++ "]" ++ regexPurifyString(rest);
}

concrete production rtoeps
r::Regex_R ::=
layout {}
{
  r.regString = "";
}

concrete production rtoDR
r::Regex_R ::= dr::Regex_DR
layout {}
{
  r.regString = dr.regString;
}

concrete production rtoDR_bar_R
r::Regex_R ::= first::Regex_DR sep::Choice_t rest::Regex_R
layout {}
{
  r.regString = first.regString ++ "|" ++ rest.regString;
}

concrete production dRtoUR_RR
dr::Regex_DR ::= first::Regex_UR rest::Regex_RR
layout {}
{
  dr.regString = first.regString ++ rest.regString;
}

concrete production dRtoUR_star_RR
dr::Regex_DR ::= first::Regex_UR sep::Kleene_t rest::Regex_RR
layout {}
{
  forwards to dRtoUR_RR(regex_kleene_of(first), rest);
}

abstract production regex_kleene_of
dr::Regex_UR ::= r::Regex_UR
{
  dr.regString = r.regString ++ "*";
}

concrete production dRtoUR_plus_RR
dr::Regex_DR ::= first::Regex_UR sep::Plus_t rest::Regex_RR
layout {}
{
  forwards to dRtoUR_RR(regex_plus_of(first), rest);
}

abstract production regex_plus_of
dr::Regex_UR ::= r::Regex_UR
{
  dr.regString = r.regString ++ "+";
}

concrete production dRtoUR_question_RR
dr::Regex_DR ::= first::Regex_UR sep::Optional_t rest::Regex_RR
layout {}
{
  forwards to dRtoUR_RR(regex_opt_of(first), rest);
}

abstract production regex_opt_of
dr::Regex_UR ::= r::Regex_UR
{
  dr.regString = r.regString ++ "?";
}

concrete production rRtoDR
rr::Regex_RR ::= dr::Regex_DR
layout {}
{
  rr.regString = dr.regString;
}

concrete production rRtoeps
rr::Regex_RR ::=
layout {}
{
  rr.regString = "";
}

concrete production uRtoCHAR
ur::Regex_UR ::= char::Regex_CHAR
layout {}
{
  ur.regString = char.regString;
}

concrete production uRtowildcard
ur::Regex_UR ::= wildcard::RegexWildcard_t
layout {}
{
  ur.regString = ".";
}

concrete production uRtolb_G_rb
ur::Regex_UR ::= lb::RegexLBrack_t g::Regex_G rb::RegexRBrack_t
layout {}
{
  ur.regString = "[" ++ g.regString ++ "]";
}

concrete production uRtolb_not_G_rb
ur::Regex_UR ::= lb::RegexLBrack_t sep::RegexNot_t g::Regex_G rb::RegexRBrack_t
layout {}
{
  ur.regString = "[^" ++ g.regString ++ "]";
}

concrete production uRtolp_R_rp
ur::Regex_UR ::= lp::RegexLParen_t r::Regex_R rp::RegexRParen_t
layout {}
{
  ur.regString = "(" ++ r.regString ++ ")";
}

concrete production gtoUG_RG
g::Regex_G ::= ug::Regex_UG rg::Regex_RG
layout {}
{
  g.regString = ug.regString ++ rg.regString;
}

concrete production uGtoCHAR
ug::Regex_UG ::= char::Regex_CHAR
layout {}
{
  ug.regString = char.regString;
}

concrete production uGtoCHAR_dash_CHAR
ug::Regex_UG ::= leastchar::Regex_CHAR sep::Range_t greatestchar::Regex_CHAR
layout {}
{
  ug.regString = leastchar.regString ++ "-" ++ greatestchar.regString;
}

concrete production rGtoG
rg::Regex_RG ::= g::Regex_G
layout {}
{
  rg.regString = g.regString;
}

concrete production rGtoeps
rg::Regex_RG ::=
layout {}
{
  rg.regString = "";
}

concrete production cHARtochar
top::Regex_CHAR ::= char::RegexChar_t
layout {}
{
  top.regString = char.lexeme;
}

concrete production cHARtoescaped
top::Regex_CHAR ::= esc::EscapedChar_t
layout {}
{
  top.regString = esc.lexeme;
}

