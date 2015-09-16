/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class DeclVar extends Decl
{
  Token semicol;
  Exp exp;
  Token assign;
  NameToken id;
  Type type;

  DeclVar(List<StackItem> stack)
  {
    semicol = stack.removeLast().token;
    exp = stack.removeLast().token;
    assign = stack.removeLast().token;
    id = stack.removeLast().token;
    type = stack.removeLast().token;
  }
  String getTokenType()
  {
    return "<declvar>";
  }
  String ssmCode(SSMCodeGen codegen){ return ""; }
}