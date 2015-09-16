/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
library splgrammar;

import "../splcompiler.dart";

part "exp.dart";
part "type.dart";
part "field.dart";
part "decl.dart";
part "declvar.dart";
part "declfun.dart";
part "functionbegin.dart";
part "funcall.dart";
part "farg.dart";

part "llartable.dart";
part "splgrammar.dart";

part "stmt.dart";
part "stmt_decl.dart";
part "stmt_funcall.dart";
part "stmt_if.dart";
part "stmt_return.dart";
part "stmt_while.dart";

abstract class SPLBase implements Token
{

  String getTokenType();
  String ssmCode(SSMCodeGen codegen);
}