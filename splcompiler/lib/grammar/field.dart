/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class Field extends SPLBase
{
    String getTokenType()
    {
      return "<field>";
    }

    Token dot;
    TerminalToken op;
    Field field;
    Field(List<StackItem> stack)
    {
      field = stack.removeLast().token;
      //remove empty field
      if(field.dot == null)
        field = null;
      op = stack.removeLast().token;
      dot = stack.removeLast().token;
    }

    Field.empty(List<StackItem> stack)
    {
      //stack.removeLast();
    }

    String ssmCode(SSMCodeGen codegen)
     {
      if(dot == null)
        return "";

      String fieldcode = (field == null) ? "" : field.ssmCode(codegen);
      return ssmCodeSingleField() + fieldcode;
     }

    String ssmCodeSingleField()
    {
      if(op.token == "hd")
        return "LDA 2\n";
      if(op.token == "tl")
         return "LDA 1\n";
      if(op.token == "fst")
         return "LDA 1\n";
      if(op.token == "snd")
         return "LDA 2\n";
      return "";
    }
    String ssmCodeSingleFieldStore()
    {
      if(op.token == "hd")
        return "STA 2\n";
      if(op.token == "tl")
         return "STA 1\n";
      if(op.token == "fst")
         return "STA 1\n";
      if(op.token == "snd")
         return "STA 2\n";
      return "";
    }

  String ssmStoreCode()
  {
    if(field == null)
      return ssmCodeSingleFieldStore();
    else
      return ssmCodeSingleField() + field.ssmStoreCode();
  }
}