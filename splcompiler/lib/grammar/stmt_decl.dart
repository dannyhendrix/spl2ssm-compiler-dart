/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StmtDecl extends Stmt
{
  Token token;
  NameToken id;
  Field field;
  Token assign;
  Exp exp;
  Token concat;

  StmtDecl(List<StackItem> stack)
  {
    concat = stack.removeLast().token;
    exp = stack.removeLast().token;
    assign = stack.removeLast().token;
    field = stack.removeLast().token;
    token = id = stack.removeLast().token;
    if(field.dot == null)
      field = null;
  }

  String loadvar(SSMCodeGen codegen)
  {
    String loadvar;
    if(codegen.locals.containsKey(id.token))
    {
      int adr = codegen.locals[id.token];
      loadvar = "LDLA $adr\n"
          + "//ANNOTE SP 0 0 expressionColour \"Address of ${id.token}\"\n";
    }
    else if(codegen.args.containsKey(id.token))
    {
      int adr = codegen.args[id.token];
      loadvar = "LDLA $adr\n"
          + "//ANNOTE SP 0 0 expressionColour \"Address of ${id.token}\"\n";
    }
    else
    {
      int adr = codegen.globals[id.token];
      loadvar = "LDC $adr\n"
          +"//ANNOTE SP 0 0 globalsColour \"Address of ${id.token}\"\n";
    }
    return loadvar;
  }

  String ssmCode(SSMCodeGen codegen)
  {
    //exp code
    //load varadr
    //
    if(field == null)
    return exp.ssmCode(codegen)
        +  loadvar(codegen)
        + "STA 0\n";
    return exp.ssmCode(codegen)
            +  loadvar(codegen)
            + "LDA 0\n"
            + field.ssmStoreCode();
  }
}