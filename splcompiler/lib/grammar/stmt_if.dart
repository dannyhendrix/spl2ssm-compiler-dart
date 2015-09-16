/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StmtIf extends Stmt
{
  Token token;
  Token tokenif;
  Token condopen;
  Token condclose;
  Exp cond;
  Stmt stmt;
  Token tokenelse;
  Stmt stmtelse;

  StmtIf(List<StackItem> stack)
  {
    stmt = stack.removeLast().token;
    condclose = stack.removeLast().token;
    cond = stack.removeLast().token;
    condopen = stack.removeLast().token;
    tokenif = token = stack.removeLast().token;
  }

  StmtIf.ifelse(List<StackItem> stack)
  {
    stmtelse = stack.removeLast().token;
    tokenelse = stack.removeLast().token;
    stmt = stack.removeLast().token;
    condclose = stack.removeLast().token;
    cond = stack.removeLast().token;
    condopen = stack.removeLast().token;
    tokenif = token = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
  {
    String lbl = codegen.createLabel("afterif");
    if(stmtelse == null)
      return cond.ssmCode(codegen)
          + "BRF $lbl \n"
          + stmt.ssmCode(codegen)
          + "$lbl:\n";
    String lblelse = codegen.createLabel("else");
    return cond.ssmCode(codegen)
        + "BRF $lblelse \n"
        + stmt.ssmCode(codegen)
        + "BRA $lbl\n"
        + "$lblelse:\n"
        + stmtelse.ssmCode(codegen)
        + "$lbl:\n";
  }
}