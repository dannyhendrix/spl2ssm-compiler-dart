/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

abstract class Exp extends SPLBase
{
  String getTokenType()
  {
    return "<exp>";
  }
}

class ExpWrapped extends Exp
{
  Token token;
  Token open;
  Token close;
  Field exp;
  ExpWrapped(List<StackItem> stack)
  {
    close = stack.removeLast().token;
    exp = stack.removeLast().token;
    open = token = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
   {
    return exp.ssmCode(codegen);
   }
}

class ExpId extends Exp
{
  NameToken id;
  Field field;
  ExpId(List<StackItem> stack)
  {
    field = stack.removeLast().token;
    id = stack.removeLast().token;
  }

  String ssmCode(SSMCodeGen codegen)
     {
    String loadvar;
    if(codegen.locals.containsKey(id.token))
    {
      int adr = codegen.locals[id.token];
      loadvar = "LDL $adr\n";
    }
    else if(codegen.args.containsKey(id.token))
        {
          int adr = codegen.args[id.token];
          loadvar = "LDL $adr\n";
        }
      else
      {
        int adr = codegen.globals[id.token];
        loadvar = "LDC $adr\n"
            +"LDA 0\n";
      }
      return loadvar + field.ssmCode(codegen);
     }
}
class ExpOp2 extends Exp
{
  Exp expa;
  Exp expb;
  TerminalToken op;
  static final Map<String,String> op2commands =
    {"+":"ADD","-":"SUB","*":"MUL","/":"DIV","%":"MOD","==":"EQ",
      "<":"LT",">":"GT","<=":"LE",">=":"GE","!=":"NE","&&":"AND","||":"OR"
    };
  ExpOp2(List<StackItem> stack)
  {
    expb = stack.removeLast().token;
    op = stack.removeLast().token;
    expa = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
   {
    if(op.token == ":")
      return expa.ssmCode(codegen)
          + expb.ssmCode(codegen)
          + codegen.halloc(2)
          + "LDR RR\n"
          + "STMA 1 2\n"
          + "LDR RR\n";
    return expa.ssmCode(codegen) + expb.ssmCode(codegen) + op2commands[op.token] +"\n";
   }
}
class ExpOp1 extends Exp
{
  Exp exp;
  TerminalToken op;
  ExpOp1(List<StackItem> stack)
  {
    exp = stack.removeLast().token;
    op = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
     {
    if(op.token == "!")
      return exp.ssmCode(codegen)+"NOT\n";
    else
      return exp.ssmCode(codegen)+"NEG\n";
     }
}
class ExpInt extends Exp
{
  IntToken token;
  ExpInt(List<StackItem> stack)
  {
    token = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
   {
    return "LDC ${token.intval} \n";
   }
}
class ExpTrue extends Exp
{
    TerminalToken token;
    ExpTrue(List<StackItem> stack)
    {
      token = stack.removeLast().token;
    }
    String ssmCode(SSMCodeGen codegen)
     {
       return "LDC ${SSMCodeGen.TRUE} \n";
     }
}
class ExpFalse extends Exp
{
  TerminalToken token;
   ExpFalse(List<StackItem> stack)
   {
     token = stack.removeLast().token;
   }
   String ssmCode(SSMCodeGen codegen)
   {
     return "LDC ${SSMCodeGen.FALSE} \n";
   }
}
class ExpFuncall extends Exp
{
  FunCall funcall;
  ExpFuncall(List<StackItem> stack)
    {
      funcall = stack.removeLast().token;
    }
  String ssmCode(SSMCodeGen codegen)
   {
     return funcall.ssmCode(codegen)+"LDR RR\n";
   }
}
class ExpEmptyList extends Exp
{
  Token open;
  Token close;
  ExpEmptyList(List<StackItem> stack)
  {
    close = stack.removeLast().token;
    open = stack.removeLast().token;
  }
  String ssmCode(SSMCodeGen codegen)
       {
         return "LDC ${SSMCodeGen.EMPTYLIST} \n";
       }
}
class ExpTuple extends Exp
{
  Token open;
  Token close;
  Token comma;
  Exp expa;
  Exp expb;

  ExpTuple(List<StackItem> stack)
    {
      close = stack.removeLast().token;
      expb = stack.removeLast().token;
      comma = stack.removeLast().token;
      expa = stack.removeLast().token;
      open = stack.removeLast().token;
    }
  String ssmCode(SSMCodeGen codegen)
    {
      return expa.ssmCode(codegen)
          + expb.ssmCode(codegen)
          + codegen.halloc(2)
          + "LDR RR\n"
          + "STMA 1 2 \n"
          + "LDR RR \n";
    }
}
