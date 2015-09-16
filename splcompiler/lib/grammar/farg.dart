/**
 * Compiler SPL to SSM (Simple stack machine)
 * Author: Danny Hendrix
 * Original authors (Haskell): Danny Hendrix, Harm Berntsen
 */
part of splgrammar;

abstract class FArg extends SPLBase
{

  String getTokenType()
  {
    return "<farg>";
  }
}