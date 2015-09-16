/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splcompiler;

class SSMCodeGen
{
  static const int HEAP_START = 3000;
  static const int TRUE = 0xFFFFFFFF;
  static const int FALSE = 0;
  static const int EMPTYLIST = 0;
  static int labid = 0;

  Map<String,int> globals = new Map<String,int>();
  Map<String,int> locals = new Map<String,int>();
  Map<String,int> args = new Map<String, int>();
  bool halloccodeneeded = false;

  String process(List<Decl> decls)
  {
    int cglobals = 0;
    String initglob = "";
    String funcdecl = "";
    String domain = "HALT\n";
    int adr = HEAP_START;

    for(Decl d in decls)
    {
      if(d is DeclVar)
      {
        DeclVar dv = d;
        globals[dv.id.token] = adr;
        initglob += dv.exp.ssmCode(this)+"LDC $adr\nSTA 0\n";
        adr++;
        cglobals++;
      }
      if(d is DeclFun)
      {
        DeclFun df = d;
        if(df.id.token == "main")
        {
          if(df.returntype == null)
            domain = "BSR main \n"
                + "HALT\n";
          else
            domain = "BSR main \n"
              + "LDR RR\n"
              + "TRAP  0\n"
              + "HALT\n";
        }
        funcdecl += df.ssmCode(this);
      }

    }
    String increaseHP = "LDR HP\nLDC $cglobals\nADD\nSTR HP\n";

    return increaseHP + initglob + domain + funcdecl + hallocCode();
  }


  String hallocCode()
  {
    if(!halloccodeneeded)
      return "";
    return "halloc:\n"
        +"LDR HP\n"
        +"STR RR\n"
        +"LDS -1\n"
        +"STH\n"
        +"AJS -1\n"
        +"LDS -1\n"
        +"LDC 1\n"
        +"SUB\n"
        +"LDR HP\n"
        +"ADD\n"
        +"STR HP\n"
        +"RET\n";
  }
  String halloc(int size)
  {
    if(size == 0)
      return "";
    halloccodeneeded = true;
    return "LDC ${size+1}\n"
      + "BSR \"halloc\"\n"
      + "AJS -1\n";
  }

  String createLabel(String s)
  {
    return "${s}_$labid";
  }
}