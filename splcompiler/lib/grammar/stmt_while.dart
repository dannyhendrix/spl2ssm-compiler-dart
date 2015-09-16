/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StmtWhile extends Stmt
{
  Token token;
  Token tokenwhile;
  Token condopen;
  Token condclose;
  Exp cond;
  Stmt stmt;

  StmtWhile(List<StackItem> stack)
  {
    stmt = stack.removeLast().token;
    condclose = stack.removeLast().token;
    cond = stack.removeLast().token;
    condopen = stack.removeLast().token;
    tokenwhile = token = stack.removeLast().token;
  }

  String ssmCode(SSMCodeGen codegen)
    {
      String lbl = codegen.createLabel("afterwhile");
      String lblwhile = codegen.createLabel("checkwhile");
      return "$lblwhile:\n"
            + cond.ssmCode(codegen)
            + "BRF $lbl \n"
            + stmt.ssmCode(codegen)
            + "BRA $lblwhile \n"
            + "$lbl:\n";
    }
}