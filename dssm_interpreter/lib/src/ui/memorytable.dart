/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

/**
 * UI table to show stack/heap memory
 */
class MemoryTable
{
  Element get element => memorytable;
  final TableElement memorytable = new TableElement();
  final Map<int,TableCellElement> cells = new Map<int,TableCellElement>();
  final List<Element> el_pointer = new List<Element>();
  final Instructions instructions;
  //int ptr = 0;
  int id = 0;
  MemoryTable(this.instructions)
  {
    for(int i = 0; i < 3; i++)
    {
      DivElement p = new DivElement();
      p.className="pointer$i";
      el_pointer.add(p);
    }
  }


  void setPointer(int adr, int p)
  {
    if(adr >= 0 && adr < id)
    {
      print("pointer a $adr $p");
      while(adr >= 0 && !cells.containsKey(adr)) adr--;
      cells[adr].parent.hidden = false;
      cells[adr].parent.firstChild.append(el_pointer[p]);
    }
    else
    {
      print("pointer b $adr $p");
      while(id < adr)
        addCell("0",true);
      addCell("0");
      cells[adr].parent.hidden = false;
      cells[adr].parent.firstChild.append(el_pointer[p]);
    }
    //ptr = adr;
  }

  void addCell(String ins,[bool hidden = false])
  {
    TableRowElement tr = new TableRowElement();
    if(hidden)
      tr.hidden = true;
    TableCellElement td = new TableCellElement();
    TableCellElement tdi = new TableCellElement();
    td.text = ins;
    cells[id] = td;
    tdi.text = (id++).toString();
    tr.append(tdi);
    tr.append(td);
    memorytable.append(tr);

    //setPointer(ptr);
  }

  void changeInstruction(int key, int val)
  {
    if(id > key+1)
    {
      print(key);
      cells[key].parent.hidden = false;
      cells[key].text = val.toString();
    }
    else if(id == key+1)
    {
      cells[key].text = val.toString();
      addCell("0");
    }
    else
    {
      while(id < key)
        addCell("0",true);
      addCell(val.toString());
      addCell("0");
    }
  }
  
  void loadProgram(List<int> input)
  {
    id = 0;
    //el_pointer[0].id="pointer";
    memorytable.children.clear();
    cells.clear();
    int i = 0;
    for(int i = 0; i < input.length; i++)
    //for(int ins in input)
    {
      int ins = input[i];
      Instruction instr = instructions.getInstruction(ins);
      String str = instr.name;
      for(int j = 0; j<instr.funarg; j++)
      {
        str += " ${input[++i]}";

      }
      addCell(str);
      id += instr.funarg;
    }
  }
}

class ProgramTable extends MemoryTable
{
  ProgramTable(Instructions i) : super(i);

  void loadList(List<int> input)
  {
    id = 0;
    memorytable.children.clear();
    cells.clear();
    for(int i = 0; i < input.length; i++)
    {
      int ins = input[i];
      Instruction instr = instructions.getInstruction(ins);
      String str = instr.name;
      for(int j = 0; j<instr.funarg; j++)
        str += " ${input[++i]}";
      addCell(str);
      id += instr.funarg;
    }
  }
}