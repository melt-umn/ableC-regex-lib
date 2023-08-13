grammar edu:umn:cs:melt:exts:ableC:regex;

imports edu:umn:cs:melt:ableC:abstractsyntax:host as abs;
imports edu:umn:cs:melt:ableC:abstractsyntax:construction as abs;
imports edu:umn:cs:melt:ableC:abstractsyntax:env as abs;

imports silver:langutil;
imports silver:langutil:pp;

abstract production regexLiteralExpr
top::abs:Expr ::= l1::String
{
  top.pp = pp"/${text(substring(1, length(l1) - 1, l1))}/";
  propagate abs:env, abs:controlStmtContext;

  -- We check to make sure regcomp is in the environment. We could further check
  -- that it has the right type, but that can come later.

  local localErrs :: [Message] =
    (if !null(abs:lookupValue("regcomp", top.abs:env)) then [] else
      [errFromOrigin(top, "Regex literals require <regex.h> to be included.")]);

  
  forwards to
    if null(localErrs) then
      regexLiteral
    else
      abs:errorExpr(localErrs);

  
  local regExtended :: abs:Expr =
    --abs:declRefExpr(abs:name("REG_EXTENDED"));
    -- TODO: problem, these are #defines in the header file.
    abs:realConstant(
      abs:integerConstant("1", false, abs:noIntSuffix()));
  
  local regNosub :: abs:Expr =
    --abs:declRefExpr(abs:name("REG_NOSUB"))
    -- TODO: ditto problem
    abs:realConstant(
      abs:integerConstant("8", false, abs:noIntSuffix()));
  
  local regexLiteral :: abs:Expr =
    abs:stmtExpr(
      abs:foldStmt([
        -- static regex_t thisRegex;
        abs:declStmt(
          abs:variableDecls(
            abs:foldStorageClass([abs:staticStorageClass()]),
            abs:nilAttribute(),
            abs:typedefTypeExpr(abs:nilQualifier(), abs:name("regex_t")),
            abs:foldDeclarator([
              abs:declarator(
                abs:name("thisRegex"),
                abs:baseTypeExpr(),
                abs:nilAttribute(),
                abs:nothingInitializer()
              )
            ])
          )
        ),
        -- static bool uninited = 0;
        abs:declStmt(
          abs:variableDecls(
            abs:foldStorageClass([abs:staticStorageClass()]),
            abs:nilAttribute(),
            abs:directTypeExpr(abs:builtinType(abs:nilQualifier(), abs:boolType())),
            abs:foldDeclarator([
              abs:declarator(
                abs:name("uninited"),
                abs:baseTypeExpr(),
                abs:nilAttribute(),
                abs:justInitializer(
                  abs:exprInitializer(
                    abs:realConstant(
                      abs:integerConstant("1", false, abs:noIntSuffix()))))
              )
            ])
          )
        ),
        -- if(uninited) { regcomp(&thisRegex, "regstr", REG_EXTENDED | REG_NOSUB); uninited = 0; }
        abs:ifStmt(
          abs:declRefExpr(abs:name("uninited")),
          abs:seqStmt(
            abs:exprStmt(
              abs:directCallExpr(
                abs:name("regcomp"),
                abs:foldExpr([
                  abs:addressOfExpr(
                    abs:declRefExpr(abs:name("thisRegex"))
                  ),
                  -- Escape backslashes, as they're now in a string literal
                  abs:stringLiteral(substitute("\\", "\\\\", l1)),
                  abs:orBitExpr(
                    regExtended,
                    regNosub
                  )
                ])
              )
            ),
            abs:exprStmt(
              abs:eqExpr(
                abs:declRefExpr(abs:name("uninited")),
                abs:realConstant(
                  abs:integerConstant("0", false, abs:noIntSuffix())
                )
              )
            )
          ),
          abs:nullStmt()
        )
      ]),
      -- &thisRegex
      abs:addressOfExpr(
        abs:declRefExpr(abs:name("thisRegex"))
      )
    );
}

abstract production regexMatch
top::abs:Expr ::= text::abs:Expr  re::abs:Expr
{
  top.pp = pp"(${text}) ~= (${re})";
  propagate abs:env, abs:controlStmtContext;

  -- Yep, a *value* item. C. lol.
  local regext :: [abs:ValueItem] = abs:lookupValue("regex_t", top.abs:env);

  local localErrs :: [Message] =
    (if !null(regext) then [] else
      [errFromOrigin(top, "Regex match operators require <regex.h> to be included.")]) ++
    (if abs:compatibleTypes(
           text.abs:typerep,
	   abs:pointerType(abs:nilQualifier(), abs:builtinType(abs:consQualifier(abs:constQualifier() ,abs:nilQualifier()), abs:signedType(abs:charType()))),
	   true, true) then [] else
      [errFromOrigin(top, "First operand to =~ must be const char * (got " ++ abs:showType(text.abs:typerep) ++ ")")]) ++
    (if abs:compatibleTypes(re.abs:typerep, abs:pointerType(abs:nilQualifier(), head(regext).abs:typerep), true, true) then [] else
      [errFromOrigin(top, "Second operand to =~ must be regex_t * (got " ++ abs:showType(re.abs:typerep) ++ ")")]);

  forwards to
    if null(localErrs) then
      matchingExpr
    else
      -- Remember not to supress subexpressions' errors.
      abs:errorExpr(localErrs ++ text.errors ++ re.errors);

  
  local zero :: abs:Expr =
    abs:realConstant(
      abs:integerConstant("0", false, abs:noIntSuffix()));
  
  local matchingExpr :: abs:Expr =
    -- REG_NOMATCH != regexec(re, text, 0, 0, 0)
    abs:notEqualsExpr(
      abs:declRefExpr(abs:name("REG_NOMATCH")),
      abs:directCallExpr(
        abs:name("regexec"),
        abs:foldExpr([
          re,
          text,
          zero, zero, zero
        ])
      )
    );
{-  
    -- matchRegex (r, t)
    abs:directCallExpr(
      abs:name("matchRegex"),
      abs:foldExpr([
        r,
        text])
    );-}
}


