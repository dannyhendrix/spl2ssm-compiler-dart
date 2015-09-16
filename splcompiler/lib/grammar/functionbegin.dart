/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

abstract class FunctionBegin extends SPLBase
{
  String getTokenType()
      {
        return "<functionbegin>";
      }
}
class FunctionBeginVarDecl extends FunctionBegin
{
  DeclVar decl;
  FunctionBegin next;

  FunctionBeginVarDecl(List<StackItem> stack)
  {
    next = stack.removeLast().token;
    decl = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen){ return ""; }
}

class FunctionBeginStmt extends FunctionBegin
{
  Stmt stmt;

  FunctionBeginStmt(List<StackItem> stack)
  {
    stmt = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen){ return ""; }
}