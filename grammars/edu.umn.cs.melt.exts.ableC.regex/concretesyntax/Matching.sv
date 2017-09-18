grammar edu:umn:cs:melt:exts:ableC:regex:concretesyntax;

marking terminal RegexMatch_t '=~';

concrete productions top::cnc:AddMulNoneOp_c
| '=~'
    { top.ast = regexMatch(top.cnc:leftExpr, top.cnc:rightExpr,
        location=top.cnc:exprLocation); }

