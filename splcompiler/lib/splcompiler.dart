/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
library splcompiler;

import "grammar/splbase.dart";

part "tokenizer.dart";
part "token.dart";
part "ssmcodegen.dart";