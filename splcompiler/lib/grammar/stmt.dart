/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

abstract class Stmt extends SPLBase
{
  String getTokenType()
  {
    return "<stmt>";
  }
}

class StmtWrapped extends Stmt
{
  Token token;
  Token open;
  Token close;
  StmtStar stmt;
  StmtWrapped(List<StackItem> stack)
  {
    close = stack.removeLast().token;
    stmt = stack.removeLast().token;
    open = token = stack.removeLast().token;
    if(stmt.stmt == null)
      stmt = null;
  }
  String ssmCode(SSMCodeGen codegen)
   {
    return stmt.ssmCode(codegen);
   }
}

class StmtStar extends SPLBase
{
  String getTokenType()
  {
    return "<stmtstar>";
  }

  Token token;
  StmtStar next;
  Stmt stmt;

  StmtStar(List<StackItem> stack)
  {
    next = stack.removeLast().token;
    token = stmt = stack.removeLast().token;
    //remove empty field
    if(next.token == null)
      next = null;
  }

  StmtStar.empty(List<StackItem> stack)
  {
  }
  String ssmCode(SSMCodeGen codegen)
  {
    if(next == null)
      return stmt.ssmCode(codegen);
    return stmt.ssmCode(codegen) + next.ssmCode(codegen);
  }
}