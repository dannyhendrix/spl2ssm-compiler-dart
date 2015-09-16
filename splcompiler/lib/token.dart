/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splcompiler;

abstract class Token
{
  String getTokenType();
}

abstract class ParseToken implements Token
{
  String token;
  int line;
  int index;

  ParseToken(this.line, this.index, this.token);

  String getTokenType()
  {
    return token;
  }
}

class NameToken extends ParseToken
{
  NameToken (int l, int i, String t): super(l,i,t);
  String getTokenType()
   {
     return "<id>";
   }
}

class TerminalToken extends ParseToken
{
  TerminalToken (int l, int i, String t): super(l,i,t);
}
class IntToken extends ParseToken
{
  int intval;
  IntToken (int l, int i, String t): super(l,i,t)
  {
    intval = int.parse(t);
  }
  String getTokenType()
 {
   return "<int>";
 }
}

