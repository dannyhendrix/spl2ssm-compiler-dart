
import "../lib/splcompiler.dart";
import "../lib/grammar/splbase.dart";
import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main()
{
  Compiler s = new Compiler();
  s.compile("Int a = 6;");
  String path = "D:/master ic/compiler construction/workspace/compilerconstruction/samples/sample.spl";
  String source = "";
    int lineNumber = 1;
    Stream<List<int>> stream = new File(path).openRead();
    stream
    .transform(UTF8.decoder)
    //.transform(const LineSplitter())
    .listen((source)
    {
      //write to file
      File out = new File(path+".dart.ssm");

      out.writeAsString(s.compile(source), mode: FileMode.APPEND)
          .then((_) { print('Compiled to $path.dart.ssm.'); });
    });
}

class Compiler
{

  String compile(String s)
  {
    Tokenizer t = new Tokenizer();
    t.parse(s);

    SPLGrammar g = new SPLGrammar();
    g.processTokens(t.tokens);

    SSMCodeGen ssm = new SSMCodeGen();
    return ssm.process(g.parsed);
  }
}
