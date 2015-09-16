/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class ActArgs extends SPLBase
{
  Token token;
  Exp exp;
  Token comma;
  ActArgs arg;
  int length = 0;

  ActArgs(List<StackItem> stack)
  {
    token = exp = stack.removeLast().token;
    length++;
  }
  ActArgs.args(List<StackItem> stack)
   {
     arg = stack.removeLast().token;
     comma = stack.removeLast().token;
     token = exp = stack.removeLast().token;
     length = arg.length + 1;
   }
  String getTokenType()
    {
      return "<actargs>";
    }
  String ssmCode(SSMCodeGen codegen)
        {
    if(arg == null)
      return exp.ssmCode(codegen);
      return exp.ssmCode(codegen)+arg.ssmCode(codegen);
        }
  String ssmCodeReversed(SSMCodeGen codegen)
  {
    if(arg == null)
          return exp.ssmCode(codegen);
        return arg.ssmCodeReversed(codegen)+exp.ssmCode(codegen);
   }
}

class FunCall extends SPLBase
{
  String getTokenType()
      {
        return "<funcall>";
      }
  Token token;
  NameToken id;
  Token argopen;
  Token argclose;
  ActArgs arg;

  FunCall(List<StackItem> stack)
    {
      argclose = stack.removeLast().token;
      argopen = stack.removeLast().token;
      id = token = stack.removeLast().token;
    }
  FunCall.args(List<StackItem> stack)
  {
    argclose = stack.removeLast().token;
    arg = stack.removeLast().token;
    argopen = stack.removeLast().token;
    id = token = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
      {
    //default functions
    if(id.token == "print")
      return arg.ssmCode(codegen) + "TRAP 0\n";
    if(id.token == "isEmpty")
      return "LDC ${SSMCodeGen.EMPTYLIST}\n"
        + "EQ\n"
        + "STR RR\n";
    if(arg == null)
      return "AJS 1\n"
              + "BSR ${id.token}\n"
              + "AJS -1\n"
              ;
    int arglength = arg.length;
    return arg.ssmCode(codegen)
        + "AJS 1\n"
        + "BSR ${id.token}\n"
        + "AJS ${-arglength-1}\n"
        ;
      }
}