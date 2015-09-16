/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

class Instructions
{
    static const int TRUE = 0xFFFFFFFF;
    static const int FALSE = 0;

    static const int HA = 0;//heap start address
    static const int SA = 0;//stack start address

    //registers
    static const int PC = 0;
    static const int SP = 1;
    static const int MP = 2;
    static const int HP = 3;
    static const int RR = 4;

    //instructions
    //binint
    static const int ADD = 1;
    static const int AND = 2;
    //static const int CMP = 3;
    static const int DIV = 4;
    static const int LSL = 5;
    static const int LSR = 6;
    static const int MOD = 7;
    static const int MUL = 8;
    static const int OR = 9;
    static const int ROL = 10;
    static const int ROR = 11;
    static const int SUB = 12;
    static const int XOR = 13;

    static const int EQ = 14;
    static const int NE = 15;
    static const int LT = 16;
    static const int GT = 17;
    static const int LE = 18;
    static const int GE = 19;

    //uniop
    static const int NEG = 32;
    static const int NOT = 33;

    //control
    static const int BRA = 104;
    static const int BRF = 108;
    static const int BRT = 109;
    static const int BSR = 112;
    static const int JSR = 120;
    static const int RET = 168;
    //halt/skip
    static const int NOP = 0;//164
    static const int HALT = 116;

    //constants
    static const int LDC = 132;

    //swapping
    static const int SWP = 188;
    static const int SWPR = 192;
    static const int SWPRR = 196;

    //print
    static const int TRAP = 200;

    //registers
    static const int STR = 180;
    static const int LDR = 144;
    static const int LDRR = 148;

    //adress
    static const int STA = 172;
    static const int STMA = 174;
    static const int LDA = 124;
    static const int LDMA = 126;
    static const int LDAA = 128;

    //locals
    static const int LINK = 160;
    static const int UNLINK = 204;
    static const int STL = 176;
    static const int STML = 178;
    static const int LDL = 136;
    static const int LDML = 138;
    static const int LDLA = 140;

    //stack
    static const int AJS = 100; // adjust stack pointer
    static const int STS = 184;
    static const int STMS = 186;
    static const int STSA = 302;
    static const int LDS = 152;
    static const int LDMS = 154;
    static const int LDSA = 156;

    //heap
    static const int LDH = 208;
    static const int LDMH = 212;
    static const int STH = 214;
    static const int STHA = 301;
    static const int STMH = 216;
    static const int LDHA = 300;

    static final Map<String, int> staticparameters = {
      "SP" : SP,
      "HP" : HP,
      "PC" : PC,
      "MP" : MP,
      "RR" : RR,
      "TRUE" : TRUE,
      "FALSE" : FALSE,
      "HA" : HA,
      "SA" : SA
    };
    static final Map<String, int> instructionLookup = {
      //binint
      "ADD" : ADD,
      "AND" : AND,
      //"CMP" : CMP,
      "DIV" : DIV,
      "LSL" : LSL,
      "LSR" : LSR,
      "MOD" : MOD,
      "MUL" : MUL,
      "OR" : OR,
      "ROL" : ROL,
      "ROR" : ROR,
      "SUB" : SUB,
      "XOR" : XOR,

      "EQ" : EQ,
      "NE" : NE,
      "LT" : LT,
      "GT" : GT,
      "LE" : LE,
      "GE" : GE,

      //uniop
      "NEG" : NEG,
      "NOT" : NOT,

      //control
      "BRA" : BRA,
      "BRF" : BRF,
      "BRT" : BRT,
      "BSR" : BSR,
      "JSR" : JSR,
      "RET" : RET,
      //halt/skip
      "NOP" : NOP,
      "HALT" : HALT,

      //constants
      "LDC" : LDC,

      //swapping
      "SWP" : SWP,
      "SWPR" : SWPR,
      "SWPRR" : SWPRR,

      //print
      "TRAP" : TRAP,

      //registers
      "STR" : STR,
      "LDR" : LDR,
      "LDRR" : LDRR,

      //adress
      "STA" : STA,
      "STMA" : STMA,
      "LDA" : LDA,
      "LDMA" : LDMA,
      "LDAA" : LDAA,

      //locals
      "LINK" : LINK,
      "UNLINK" : UNLINK,
      "STL" : STL,
      "STML" : STML,
      "LDL" : LDL,
      "LDML" : LDML,
      "LDLA" : LDLA,

      //stack
      "AJS" : AJS, // adjust stack pointer
      "STS" : STS,
      "STMS" : STMS,
      "STSA" : STSA,
      "LDS" : LDS,
      "LDMS" : LDMS,
      "LDSA" : LDSA,

      //heap
      "LDH" : LDH,
      "LDMH" : LDMH,
      "STH" : STH,
      "STHA" : STHA,
      "STMH" : STMH,
      "LDHA" : LDHA
    };

    static final Map<int, Instruction> instructions =
    {
      ADD : new BinOpInstruction(ADD, "ADD", (int a, int b) => a+b),
      AND : new BinOpInstruction(AND, "AND", (int a, int b) => a&b),
//CMP : new OpInstruction(CMP, "CMP", (int a, int b) => a+b),
      DIV : new BinOpInstruction(DIV, "DIV", (int a, int b) => a~/b),
      LSL : new BinOpInstruction(LSL, "LSL", (int a, int b) => a<<b),
      LSR : new BinOpInstruction(LSR, "LSR", (int a, int b) => a>>b),
      MOD : new BinOpInstruction(MOD, "MOD", (int a, int b) => a%b),
      MUL : new BinOpInstruction(MUL, "MUL", (int a, int b) => a*b),
      OR : new BinOpInstruction(OR, "OR", (int a, int b) => a|b),
      ROL : new BinOpInstruction(ROL, "ROL", (int a, int b) => (a<<b)|(a >>(Interpreter.WORD-b))),
      ROR : new BinOpInstruction(ROR, "ROR", (int a, int b) => (a>>b)|(a <<(Interpreter.WORD-b))),
      SUB : new BinOpInstruction(SUB, "SUB", (int a, int b) => a-b),
      XOR : new BinOpInstruction(XOR, "XOR", (int a, int b) => a^b),

      EQ : new BinOpInstruction(EQ, "EQ", (int a, int b) => (a==b)?TRUE : FALSE),
      NE : new BinOpInstruction(NE, "NE", (int a, int b) => (a!=b)?TRUE : FALSE),
      LT : new BinOpInstruction(LT, "LT", (int a, int b) => (a<b)?TRUE : FALSE),
      GT : new BinOpInstruction(GT, "GT", (int a, int b) => (a>b)?TRUE : FALSE),
      LE : new BinOpInstruction(LE, "LE", (int a, int b) => (a<=b)?TRUE : FALSE),
      GE : new BinOpInstruction(GE, "GE", (int a, int b) => (a>=b)?TRUE : FALSE),

      NEG : new UnOpInstruction(NEG, "NEG", (int a) => -a),
      NOT : new UnOpInstruction(NOT, "NOT", (int a) => ~a),

      BRA : new BranchInstruction(BRA, "BRA", (Interpreter i) => true),
      BRF : new BranchInstruction(BRF, "BRF", (Interpreter i) => i.popFromStack() == FALSE, 1),
      BRT : new BranchInstruction(BRT, "BRT", (Interpreter i) => i.popFromStack() == TRUE, 1),
      BSR : new Instruction.withFunction(BSR,"BSR",1,0,1,(Interpreter i){
        int a = i.nextProgIns();
        int cpc = i.pc;
        i.pushToStack(cpc);
        i.pc = a;
      }),
      JSR : new Instruction.withFunction(JSR,"JSR",0,1,1,(Interpreter i){
            int a = i.popFromStack();
            int cpc = i.pc;
            i.pushToStack(cpc);
            i.pc = a;
          }),
      RET : new Instruction.withFunction(RET,"RET",0,1,0,(Interpreter i){
        i.pc = i.popFromStack();
      }),

      NOP : new Instruction.withFunction(NOP,"NOP",0,0,0,(Interpreter i){}),
      HALT : new Instruction.withFunction(HALT, "HALT", 0, 0, 0, (Interpreter i){
        i.halted = true;
      }),

      LDC : new Instruction.withFunction(LDC, "LDC", 1, 0, 1, (Interpreter i){
        i.pushToStack(i.nextProgIns());
      }),

      SWP : new Instruction.withFunction(SWP, "SWP", 0, 2, 2, (Interpreter i){
        int a = i.popFromStack();
        int b = i.popFromStack();
        i.pushToStack(a);
        i.pushToStack(b);
      }),
      SWPR : new Instruction.withFunction(SWPR, "SWPR", 1, 1, 2, (Interpreter i){
        int reg = i.nextProgIns();
        int a = i.popFromStack();
        int r = i.register.read(reg);
        i.register.write(reg, a);
        i.pushToStack(r);
      }),
      SWPRR : new Instruction.withFunction(SWPR, "SWPR", 2, 0, 0, (Interpreter i){
        int a = i.nextProgIns();
        int b = i.nextProgIns();
        int ra = i.register.read(a);
        int rb = i.register.read(b);
        i.register.write(a, rb);
        i.register.write(b, ra);
      }),

      //registers
      STR : new Instruction.withFunction(STR,"STR",1,1,0,(Interpreter i){
        i.register.write(i.nextProgIns(), i.popFromStack());
      }),
      LDR : new Instruction.withFunction(LDR,"LDR",1,0,1,(Interpreter i){
        i.pushToStack(i.register.read(i.nextProgIns()));
      }),
      LDRR : new Instruction.withFunction(LDRR,"LDRR",2,0,0,(Interpreter i){
        i.register.write(i.nextProgIns(), i.nextProgIns());
      }),

      //locals
      LINK : new Instruction.withFunction(LINK,"LINK",1,-1,1,(Interpreter i){
        i.pushToStack(i.mp);
        i.mp = i.sp/*-1*/;
        i.sp = i.sp + i.nextProgIns();
      }),
      UNLINK : new Instruction.withFunction(UNLINK,"UNLINK",0,1,0,(Interpreter i){
        i.sp = i.mp;
        i.mp = i.popFromStack();
      }),
      STL : new Instruction.withFunction(STL,"STL",1,1,0,(Interpreter i){
       i.memory.write(i.mp+i.nextProgIns(), i.popFromStack());
      }),
      STML : new Instruction.withFunction(STML,"STML",2,-1,0,(Interpreter i){
        int adr = i.mp + i.nextProgIns();
        int l = i.nextProgIns();
        while(l-- > 0)
          i.memory.write(adr++, i.popFromStack());
      }),
      LDL : new Instruction.withFunction(LDL,"LDL",1,0,1,(Interpreter i){
        int sadr = i.mp+i.nextProgIns();
        i.pushToStack(i.memory.read(sadr));
      }),
      LDML : new Instruction.withFunction(LDML,"LDML",2,0,-1,(Interpreter i){
        int sadr = i.mp+ i.nextProgIns();
        int l = i.nextProgIns();
        while(l-- > 0)
          i.pushToStack(i.memory.read(sadr++));
      }),
      LDLA : new Instruction.withFunction(LDLA,"LDLA",1,0,1,(Interpreter i){
        i.pushToStack(i.mp + i.nextProgIns());
      }),

      //stack
      AJS : new Instruction.withFunction(AJS,"AJS",1,0,0,(Interpreter i){
        i.sp += i.nextProgIns();
      }),
      STS : new Instruction.withFunction(STS,"STS",1,1,0,(Interpreter i){
       i.memory.write(i.sp+i.nextProgIns(), i.popFromStack());
      }),
      STSA : new Instruction.withFunction(STSA,"STSA",1,2,0,(Interpreter i){
        int a = i.popFromStack();
        int sadr = i.popFromStack()+i.nextProgIns();
        i.memory.write(sadr, a);
      }),
      STMS : new Instruction.withFunction(STMS,"STMS",2,-1,0,(Interpreter i){
        int adr = i.sp + i.nextProgIns();
        int l = i.nextProgIns();
        while(l-- > 0)
          i.memory.write(adr++, i.popFromStack());
      }),
      LDS : new Instruction.withFunction(LDS,"LDS",1,0,1,(Interpreter i){
        int sadr = i.sp+i.nextProgIns();
        i.pushToStack(i.memory.read(sadr));
      }),
      LDMS : new Instruction.withFunction(LDMS,"LDMS",2,0,-1,(Interpreter i){
        int sadr = i.sp+ i.nextProgIns();
        int l = i.nextProgIns();
        while(l-- > 0)
          i.pushToStack(i.memory.read(sadr++));
      }),
      LDSA : new Instruction.withFunction(LDSA,"LDSA",1,0,1,(Interpreter i){
        i.pushToStack(i.sp + i.nextProgIns());
      }),
        
        STA : new Instruction.withFunction(STA,"STA",1,2,0,(Interpreter i){
          int offset = i.nextProgIns();
          i.memory.write(i.popFromStack()+offset, i.popFromStack());
        }),

        STMA : new Instruction.withFunction(STMA,"STMA",1,-1,0,(Interpreter i){
          int hadr = i.popFromStack()+ i.nextProgIns();
          int l = i.nextProgIns();
          while(l-- > 0)
            i.memory.write(hadr++, i.popFromStack());

        }),
        LDA : new Instruction.withFunction(LDA,"LDA",1,1,1,(Interpreter i){
          int hadr = i.popFromStack() + i.nextProgIns();
          i.pushToStack(i.memory.read(hadr));
        }),
        LDMA : new Instruction.withFunction(LDMA,"LDMA",2,1,-1,(Interpreter i){
          int hadr = i.popFromStack()+ i.nextProgIns();
          int l = i.nextProgIns();
          while(l-- > 0)
            i.pushToStack(i.memory.read(hadr++));
        }),
        LDAA : new Instruction.withFunction(LDAA,"LDAA",1,1,1,(Interpreter i){
          int hadr = i.popFromStack()+ i.nextProgIns();
          i.pushToStack(hadr + i.nextProgIns());
        }),

      //heap
      STH : new Instruction.withFunction(STH,"STH",0,1,1,(Interpreter i){
        i.pushToStack(i.pushToHeap(i.popFromStack()));
      }),
      STHA : new Instruction.withFunction(STHA,"STHA",1,2,0,(Interpreter i){
        int a = i.popFromStack();
        int hadr = i.popFromStack()+i.nextProgIns();
        i.memory.write(hadr, a);
      }),
      STMH : new Instruction.withFunction(STMH,"STMH",1,-1,1,(Interpreter i){
        int l = i.nextProgIns();
        int dest = i.hp;
        while(l-- > 0)
           dest = i.pushToHeap(i.popFromStack());
        i.pushToStack(dest);
      }),
      LDH : new Instruction.withFunction(LDH,"LDH",1,1,1,(Interpreter i){
        int hadr = i.popFromStack() + i.nextProgIns();
        i.pushToStack(i.memory.read(hadr));
      }),
      LDMH : new Instruction.withFunction(LDMH,"LDMH",2,1,-1,(Interpreter i){
        int hadr = i.popFromStack()+ i.nextProgIns();
        int l = i.nextProgIns();
        while(l-- > 0)
          i.pushToStack(i.memory.read(hadr++));
      }),
      LDHA : new Instruction.withFunction(LDHA,"LDHA",1,0,1,(Interpreter i){
        i.pushToStack(i.hp + i.nextProgIns());
      }),

      TRAP : new Instruction.withFunction(TRAP, "TRAP", 1, 1, 0, (Interpreter i){
        int s = i.popFromStack();
        int a = i.nextProgIns();
        if(i.outbuffer == null)
          return;
        switch(a)
        {
          case 0:
            i.outbuffer(s.toString());
            break;
          case 1:
            if(s == TRUE)
              i.outbuffer("True");
            else
              i.outbuffer("False");
            break;
          default:
            i.outbuffer(s.toString());
            break;
        }
      })
    };

    int lookupInstruction(String name)
    {
      if(instructionLookup.containsKey(name))
        return instructionLookup[name];
      return -1;
    }

    Instruction getInstruction(int ins)
    {
      return instructions[ins];
    }

    int lookupStatic(String str)
    {
      if(staticparameters.containsKey(str))
        return staticparameters[str];
      return -1;
    }

    List<int> prependInstructions()
    {
      //if the program goes to the end of the instruction list: halt
      return [HALT];
    }
    List<int> appendInstructions()
    {
      return [];
    }
}