/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

typedef void InstructionExecute(Interpreter i);
class Instruction
{
  final String name; //instruction name
  final int id;
  final int funarg; //#arguments
  final int stackread; //#read from stack
  final int stackwrite; //#write to stack
  InstructionExecute execute;

  Instruction(this.id, this.name, this.funarg, this.stackread, this.stackwrite);
  Instruction.withFunction(this.id, this.name, this.funarg, this.stackread, this.stackwrite, this.execute);
}

typedef int BinOpExecute(int a, int b);
class BinOpInstruction extends Instruction
{
  BinOpInstruction(int id, String name, BinOpExecute method): super(id,name, 0, 2, 1)
  {
    execute = (Interpreter interpreter)
    {
      int b = interpreter.popFromStack();
      int a = interpreter.popFromStack();
      int c = method(a,b);
      interpreter.pushToStack(c);
    };
  }
}

typedef int UnOpExecute(int a);
class UnOpInstruction extends Instruction
{
  UnOpInstruction(int id, String name, UnOpExecute method): super(id,name, 0, 1, 1)
  {
    execute = (Interpreter interpreter)
    {
      int a = interpreter.popFromStack();
      int c = method(a);
      interpreter.pushToStack(c);
    };
  }
}

typedef bool BranchExecute(Interpreter i);
class BranchInstruction extends Instruction
{
  BranchInstruction(int id, String name, BranchExecute method, [int readstack = 0]): super(id,name, 1, readstack, 0)
  {
    execute = (Interpreter i)
    {
      int c = i.nextProgIns();
      if(method(i))
        i.pc = c;
    };
  }
}