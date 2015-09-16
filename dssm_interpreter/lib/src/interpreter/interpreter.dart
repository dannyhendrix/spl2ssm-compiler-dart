/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

typedef void ProgramParsed(List<int> program);
typedef void InterpreterOut(String str);

class Interpreter
{
  static const int MEMORY_SIZE = 5000;
  static const int HEAP_START = 3000;
  static const int REGISTER_SIZE = 8;
  static const int WORD = 32;

  final InterpreterOut outbuffer;
  ProgramParsed onParsed;
  final Instructions instructions;
  List<int> program;

  
  final Memory memory = new Memory.withStaticSize(MEMORY_SIZE);
  final Memory register = new Memory.withStaticSize(REGISTER_SIZE);

  Map<String, int> labels;

  bool halted = false;

  /**
   * Memory pointers
   **/
  int get pc => register.read(Instructions.PC);
  int get sp => register.read(Instructions.SP);
  int get hp => register.read(Instructions.HP);
  int get mp => register.read(Instructions.MP);

  void set pc(int val) { register.write(Instructions.PC, val); }
  void set sp(int val) { register.write(Instructions.SP, val); }
  void set hp(int val) { register.write(Instructions.HP, val); }
  void set mp(int val) { register.write(Instructions.MP, val); }

  /**
   * Helper methods
   **/
  int popFromStack() => memory.read(sp--);
  int pushToStack(int val) { int ssp = sp+1; sp++; memory.write(ssp,val); return ssp; }
  int popFromHeap() => memory.read(--hp);
  int pushToHeap(int val) { int hhp = hp; hp++; memory.write(hhp,val); return hhp; }
  int nextProgIns() => program[pc++];


  /**
   * Constructor
   **/
  Interpreter(this.instructions, this.outbuffer, {this.onParsed : null});

  void reset()
  {
    halted = false;
    hp = HEAP_START;
    sp = program.length-1+18;
    pc = 0;
    mp = sp;
  }

  /**
   * Parse program source
   **/

  void parse(String source)
  {
    program = new List<int>();
    labels = new Map<String,int>();
    halted = false;

    //predefined program header
    program.addAll(instructions.appendInstructions());

    int cpc = 0;
    //first loop: find all the labels
    source = source.replaceAllMapped(new RegExp(r'([;//].*(\n|$))|([a-zA-Z0-9_]+):|([a-zA-Z0-9-_]+)'), (Match m){
      String input;
      if(m.group(1) != null)
      {
        return "";
      }
      else if(m.group(3) != null)
      {
        input = m.group(3).toUpperCase();
        labels[input] = cpc;
        return "";
      }
      cpc++;
      return m.group(4);
    });
    //second loop: parse instructions
    Instruction currentins;
    int insarg = 0;
    source.replaceAllMapped(new RegExp(r'([a-zA-Z0-9-_]+)'), (Match m){
      String input;
      if(m.group(1) != null)
      {
        input = m.group(1).toUpperCase();
        if(insarg == 0)
        {
          int lookup = instructions.lookupInstruction(input);
          if(lookup >= 0)
          {
            currentins = instructions.getInstruction(lookup);
            insarg = currentins.funarg;
            program.add(lookup);
          }
          else
            throw new Exception("Unrecognised instruction $input ${m.group(0)}.");
        }
        else
        {
          insarg--;
          int lookup = instructions.lookupStatic(input);
          if(input.startsWith(new RegExp(r'[0-9-]')))
            program.add(int.parse(input));
          else if(lookup >= 0)
            program.add(lookup);
          else if(input.startsWith(new RegExp(r'R([0-9]+)')))
            program.add(int.parse(input.substring(1)) - 1);
          else if(labels.containsKey(input))
              program.add(labels[input]);
          else
            throw new Exception("Unexpected token $input. $labels");
        }
      }
      else
      {
        throw new Exception("Parse error ${m.group(0)}.");
      }
      return "";
    });

    //predefined program closure
    program.addAll(instructions.prependInstructions());
    
    
    if(onParsed != null)
      onParsed(program);
    
    reset();
  }

  /**
   * Run the interpreter
   **/
  void run()
  {
    while(halted == false)
      processStep();
  }

  void step()
  {
    if(halted == false)
       processStep();
  }

  void timedRun(Duration ms)
  {
    new Timer(ms, (){
      processStep();
      if(halted == false)
        timedRun(ms);
    });
  }

  /**
   * Execute 1 instruction
   **/
  void processStep()
  {
    int step = nextProgIns();
    Instruction i = instructions.getInstruction(step);
    i.execute(this);
  }
}