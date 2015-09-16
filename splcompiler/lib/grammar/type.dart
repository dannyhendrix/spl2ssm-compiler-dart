/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class Type extends SPLBase
{
  Token token;

  Type();
  Type.single(List<StackItem> stack)
  {
    token = stack.removeLast().token;
  }

  String getTokenType()
  {
    return "<type>";
  }
  String ssmCode(SSMCodeGen codegen)
  {
    return "";
  }
}

class TypeInt extends Type
{
  TypeInt(List<StackItem> stack):super.single(stack);
}
class TypeBool extends Type
{
  TypeBool(List<StackItem> stack):super.single(stack);
}
class TypeTuple extends Type
{
  Type typea;
  Type typeb;
  Token comma;
  Token close;

  TypeTuple(List<StackItem> stack)
  {
    close = stack.removeLast().token;
    typeb = stack.removeLast().token;
    comma = stack.removeLast().token;
    typea = stack.removeLast().token;
    token = stack.removeLast().token;
  }
}
class TypeList extends Type
{
  Type type;
  Token open;
  Token close;

  TypeList(List<StackItem> stack)
  {
    close = stack.removeLast().token;
    type = stack.removeLast().token;
    token = open = stack.removeLast().token;
  }
}
class TypeVoid extends Type
{
  TypeVoid(List<StackItem> stack):super.single(stack);
}
class TypeId extends Type
{
  TypeId(List<StackItem> stack):super.single(stack);
}
class TypeFunction extends Type
{
  Type typea, typeb;
  Token arrow;
  Token open;
  Token close;

  TypeFunction(List<StackItem> stack, [bool wrapped = false])
  {
    if(wrapped)
      close = stack.removeLast().token;
    typeb = stack.removeLast().token;
    arrow = stack.removeLast().token;
    typea = stack.removeLast().token;
    
    if(wrapped)
      token = open = stack.removeLast().token;
    else 
      token = typea;
  }
}