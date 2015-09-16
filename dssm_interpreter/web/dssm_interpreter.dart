/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
library dssm.interpreter;

import 'dart:html';
import "package:dssm_interpreter/dssm_interpreter.dart";

void main() 
{
  InterpreterUI ui = new InterpreterUI();
  document.body.append(ui.element);
  
  String src = "ldc 3\nlabel:ldc 5\nadd\ntrap 0\nhalt";
  ui.setSource(src);
}