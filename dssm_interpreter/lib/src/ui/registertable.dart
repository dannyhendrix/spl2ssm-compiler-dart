/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

/**
 * UI to display register
 */
class RegisterTable
{
  Element get element => registertable;
  final TableElement registertable = new TableElement();
  final List<TableCellElement> cells = new List<TableCellElement>();

  RegisterTable()
  {
    TableRowElement tr = new TableRowElement();
    TableRowElement trh = new TableRowElement();
    for(int i = 0; i < Interpreter.REGISTER_SIZE; i++)
    {
      TableCellElement td = new TableCellElement();
      Element tdi = new Element.tag('th');

      td.text = 0.toString();
      String reg = "R${i+1}";
      if(i == Instructions.PC)
        reg += "(PC)";
      else if(i == Instructions.SP)
        reg += "(SP)";
      else if(i == Instructions.HP)
        reg += "(HP)";
      else if(i == Instructions.MP)
        reg += "(MP)";
      else if(i == Instructions.RR)
        reg += "(RR)";
      tdi.text = reg;
      trh.append(tdi);
      tr.append(td);

      cells.add(td);
    }
    registertable.append(trh);
    registertable.append(tr);
  }
  void changeRegister(int key, int val)
  {
    if(cells.length > key)
      cells[key].text = val.toString();
  }
}