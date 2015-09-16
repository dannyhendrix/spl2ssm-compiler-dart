/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
import 'dart:html';

import "package:splcompiler/splcompiler.dart";
import "package:splcompiler/grammar/splbase.dart";
import "package:dssm_interpreter/dssm_interpreter.dart";

void main()
{
  new CompilerUI();
}

class CompilerUI
{
  TextAreaElement txt_source;
  ButtonElement btn_sompile;
  DivElement txt_output;
  
  InterpreterUI interpreter;

  CompilerUI()
  {
    txt_source = querySelector("#txt_source");
    btn_sompile = querySelector("#btn_compile");
    txt_output = querySelector("#txt_output");

    btn_sompile.onClick.listen((Event e){
        compile(txt_source.value);
      });
    createInterpreterUI();
  }

  void compile(String s)
  {
    Tokenizer t = new Tokenizer();
    t.parse(s);
    print("tokenz");

    SPLGrammar g = new SPLGrammar();
    g.processTokens(t.tokens);
    print("processed");

    SSMCodeGen ssm = new SSMCodeGen();
    String res = ssm.process(g.parsed);
    interpreter.setSource(res);
    interpreter.interpreter.parse(res);
    interpreter.interpreter.run();
  }
  
  void createInterpreterUI()
  {
    interpreter = new InterpreterUI();
    document.body.append(interpreter.element);
  }
}
