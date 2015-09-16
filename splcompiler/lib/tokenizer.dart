/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splcompiler;

class Tokenizer
{
  List<Token> tokens = new List<Token>();

  //remaining source
  String source;
  int line = 0;
  int index = 0;

  List<String> terminals = ["if","while","return","Void","Int","Bool", "True","False","->", "else" ,"hd","tl","fst","snd"
                            ,"<=",">=","!=","==","||", "&&","+","-","*","/","%","<",">",":","!","="
                            ,"(",")","{","}",";","[","]",",","."];

  List<Function> parsers;

  Tokenizer()
  {
    //parse functions (order is important)
    parsers = [parseWhiteSpace, parseMultiComment, parseComment, parseTerminal, parseName, parseInt];
  }

  void removeCharsFromSourceStart(int length,[indexpointer = true])
  {
    if(indexpointer)
      index += length;
    source = source.substring(length);
  }
  void newLine()
  {
    index = 0;
    line++;
  }

  bool parseTerminal()
  {
    for(String t in terminals)
    {
      if(source.startsWith(t))
      {
        tokens.add(new TerminalToken(line,index,t));
        removeCharsFromSourceStart(t.length);
        return true;
      }
    }
    return false;
  }

  bool parseComment()
  {
    if(source.startsWith("//") == false)
      return false;
    while(source != "" && source[0] != "\n")
      removeCharsFromSourceStart(1);
    return true;
  }

  bool parseMultiComment()
  {
    if(!source.startsWith("/*"))
      return false;
    int depth = 1;
    removeCharsFromSourceStart(2);
    while(depth > 0 && source != "")
    {
      if(source.startsWith("*/"))
      {
        depth--;
        removeCharsFromSourceStart(2);
        continue;
      }
      if(source.startsWith("/*"))
      {
        depth++;
        removeCharsFromSourceStart(2);
        continue;
      }
      if(source.startsWith("\n"))
      {
        newLine();
        removeCharsFromSourceStart(1,false);
      }
      else
        removeCharsFromSourceStart(1);
    }
    return true;
  }

  bool parseName()
  {
    if(!source.startsWith(new RegExp(r'[a-z]')))
      return false;
    String n = "";
    while(source.startsWith(new RegExp(r'[A-Za-z0-9]')))
    {
      n += source[0];
      removeCharsFromSourceStart(1);
    }
    tokens.add(new NameToken(line,index,n));
    return true;
  }

  bool parseInt()
  {
    String n = "";
    while(source.startsWith(new RegExp(r'[0-9]')))
    {
      n += source[0];
      removeCharsFromSourceStart(1);
    }
    if(n == "")
      return false;
    tokens.add(new IntToken(line,index,n));
    return true;
  }

  bool parseWhiteSpace()
  {
    while(source.startsWith(new RegExp(r'[ \t\n\r]')))
    {
      if(source[0] == "\n")
      {
        newLine();
        removeCharsFromSourceStart(1, false);
      }
      else
        removeCharsFromSourceStart(1);
    }
    //not important if this removed something
    return false;
  }

  bool parseNext()
  {
    for(Function p in parsers)
      if(p())
        return true;
    return false;
  }

  void parse(String s)
  {
    source = s;

    while(source != "")
    {
      if(parseNext())
        continue;
      print("error: unable to parse token: $source");
      return;
    }

  }

  String tokensToString()
  {
    String s = "";
    for(ParseToken t in tokens)
    {
      s += t.token + "<br/>";
    }
    return s;
  }
}