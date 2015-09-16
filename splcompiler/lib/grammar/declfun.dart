/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class FArgsOpt extends SPLBase
{
  String getTokenType()
  {
    return "<fargsopt>";
  }

  Token token;
  FArgs fargs;
  int length = 0;

  FArgsOpt(List<StackItem> stack)
  {
    token = fargs = stack.removeLast().token;
    length = fargs.length;
  }

  FArgsOpt.empty(List<StackItem> stack)
  {
  }
  String ssmCode(SSMCodeGen codegen){ return ""; }
}

class FArgs extends SPLBase
{
  String getTokenType()
  {
    return "<fargs>";
  }

  Token token;
  Token comma;
  Type type;
  NameToken id;
  FArgs next;
  int length = 0;

  FArgs(List<StackItem> stack)
  {
    id = stack.removeLast().token;
    token = type = stack.removeLast().token;
    comma = stack.removeLast().token;

    next = stack.removeLast().token;
    length = next.length + 1;
  }

  FArgs.single(List<StackItem> stack)
  {
    id = stack.removeLast().token;
    token = type = stack.removeLast().token;
    length = 1;
  }
  String ssmCode(SSMCodeGen codegen){ return ""; }
}

class DeclFun extends Decl
{
  Token token;
  Type returntype;
  NameToken id;
  FArgsOpt args;
  FunctionBegin funcbegin;
  List<DeclVar> funcdecls;
  List<Stmt> funcstmt;
  StmtStar stmts;
  Token argopen;
  Token argclose;
  Token funopen;
  Token funclose;

  DeclFun(List<StackItem> stack)
  {
    funclose = stack.removeLast().token;
    stmts = stack.removeLast().token;
    funcbegin = stack.removeLast().token;
    funopen = stack.removeLast().token;
    argclose = stack.removeLast().token;
    args = stack.removeLast().token;
    argopen = stack.removeLast().token;
    id = stack.removeLast().token;
    returntype = token = stack.removeLast().token;
    fixFunctionBegin();
  }

  DeclFun.noreturn(List<StackItem> stack)
  {
    funclose = stack.removeLast().token;
    stmts = stack.removeLast().token;
    funcbegin = stack.removeLast().token;
    funopen = stack.removeLast().token;
    argclose = stack.removeLast().token;
    args = stack.removeLast().token;
    argopen = stack.removeLast().token;
    id = stack.removeLast().token;
    //"Void"
    token = stack.removeLast().token;
    fixFunctionBegin();
  }

  void fixFunctionBegin()
  {
    FunctionBegin b = funcbegin;
    funcstmt = new List<Stmt>();
    funcdecls = new List<DeclVar>();

    while(b != null)
    {
      if(b is FunctionBeginStmt)
      {
        FunctionBeginStmt fs = b;
        funcstmt.add(fs.stmt);
        break;
      }
      FunctionBeginVarDecl fv = b;
      funcdecls.add(fv.decl);
      b = fv.next;
    }
    if(stmts.stmt == null)
      stmts = null;
    while(stmts != null)
    {
      funcstmt.add(stmts.stmt);
      stmts = stmts.next;
    }
  }
  String ssmCodeHeader(SSMCodeGen codegen)
  {
    String vardeclcode = "";
    codegen.args = new Map<String,int>();
    FArgs fa = args.fargs;
    int i = -3;
    while(fa != null)
    {
      codegen.args[fa.id.token] = i--;
      fa = fa.next;
    }
    codegen.locals = new Map<String,int>();
    i = 1;
    for(DeclVar vd in funcdecls)
    {
      vardeclcode += vd.exp.ssmCode(codegen);
      codegen.locals[vd.id.token] = i++;
    }

    return
      "LDC ${-args.length-1}\n"
      +"STS -2\n"
      +"LINK 0\n"
      + vardeclcode;
  }
  String ssmCodeBody(SSMCodeGen codegen)
  {
    String stmtcode = "";
    for(Stmt st in funcstmt)
      stmtcode += st.ssmCode(codegen);
    return stmtcode+"UNLINK\n"
        + "RET\n";
  }
  String ssmCode(SSMCodeGen codegen)
  {
    return "${id.token}:\n" + ssmCodeHeader(codegen)+ssmCodeBody(codegen);
  }

  String getTokenType()
  {
    return "<declfun>";
  }
}