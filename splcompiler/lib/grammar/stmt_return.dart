/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StmtReturn extends Stmt
{
  Token token;
  Token tokenreturn;
  Exp exp;
  Token concat;

  StmtReturn(List<StackItem> stack)
  {
    concat = stack.removeLast().token;
    exp = stack.removeLast().token;
    token = tokenreturn = stack.removeLast().token;
  }

  StmtReturn.noexp(List<StackItem> stack)
  {
    concat = stack.removeLast().token;
    token = tokenreturn = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
  {
    if(exp == null)
       return "";
    return exp.ssmCode(codegen)
        + "STR RR\n";
  }
}