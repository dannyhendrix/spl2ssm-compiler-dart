/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

class StackItem
{
  Token token;
  int state;
  StackItem(this.token,this.state);
}

abstract class LLARTable
{
  //table
  Map<String,int> actions = new Map<String,int>();
  Map<String,int> newstates = new Map<String,int>();

  List<StackItem> stack = new List<StackItem>();

  List<Token> tokens;
  List<Decl> parsed = new List<Decl>();

  static const int ACTION_SHIFT = 0;
  static const int ACTION_REDUCE = 1;
  static const int ACTION_GOTO = 2;
  static const int ACTION_ACCEPT = 3;

  bool stop = false;

  void appendRule(int state, String key, int action, int argument)
  {
    String mkey = "${state}_$key";
    actions[mkey] = action;
    newstates[mkey] = argument;
  }

  void processTokens(List<Token> t)
  {
    this.tokens = t;
    while(!stop && (tokens.length != 0 || stack.length != 0))
    {
      int state;
      if(stack.length == 0)
        state = 0;
      else
        state = stack.last.state;
      performAction(state);
    }
  }

  void performAction(int state)
  {
    String key;
    if(tokens.length == 0)
    {
      key = "${state}_<all>";
    }
    else
    {
      Token token = tokens[0];
      key = "${state}_${token.getTokenType()}";
      if(!actions.containsKey(key))
        key = "${state}_<all>";
        if(!actions.containsKey(key))
        {
          print("Error: read in state $state is not allowed ${token.getTokenType()} $stack.");
          stop = true;
          return;
        }
    }

    if(!actions.containsKey(key))
        {
          print("Error: Expecting more tokens.");
          stop = true;
          return;
        }

    int action = actions[key];
    int argument = newstates[key];
    switch(action)
    {
      case ACTION_SHIFT:
        shift(argument);
        break;
      case ACTION_REDUCE:
        reduce(argument);
        break;
      case ACTION_GOTO:
        goto(argument);
        break;
      case ACTION_ACCEPT:
        accept();
        break;
    }
  }

  void reduce(int rule)
  {
    SPLBase newtoken = reduceToken(rule);
    tokens.insert(0,newtoken);
    //print("reduce $rule");
  }

  SPLBase reduceToken(int rule);

  void goto(int state)
  {
    Token token = tokens.removeAt(0);
    stack.add(new StackItem(token,state));
  }
  void shift(int state)
  {
    Token token = tokens.removeAt(0);
    stack.add(new StackItem(token,state));
  }
  void accept()
  {
    parsed.add(tokens.removeAt(0));
  }

}