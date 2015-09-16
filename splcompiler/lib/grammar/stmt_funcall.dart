/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StmtFunCall extends Stmt
{
  Token token;
  FunCall call;
  Token concat;

  StmtFunCall(List<StackItem> stack)
  {
    concat = stack.removeLast().token;
    token = call = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
  {
    return call.ssmCode(codegen);
  }
}