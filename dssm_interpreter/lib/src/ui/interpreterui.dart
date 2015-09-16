/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

class InterpreterUI
{
  Instructions instructions;
  Interpreter interpreter;
  
  Element element;
  TextAreaElement txt_source;
  DivElement txt_out;
  
  InterpreterUI({this.instructions})
  {
    //instructionset
    if(instructions == null)
      instructions = new Instructions();
  
    element = _createElement(); 
  }
	Element _createElement() 
	{
	  //UI elements
	  txt_source = new TextAreaElement()..classes.add("source");
	  txt_out = new DivElement()..classes.add("output");
	  //memory tables
	  MemoryTable memory = new MemoryTable(instructions);
	  //ProgramTable programtable = new ProgramTable(instructions);
	  RegisterTable registertable = new RegisterTable();
	
	  interpreter = new Interpreter(instructions, (String str){
	    txt_out.innerHtml += "$str <br/>";
	  });
	
	  interpreter.memory.listener = (int adr, int val){
	    memory.changeInstruction(adr, val);
	  };
	  
	  interpreter.register.listener = (int adr, int val){
	    registertable.changeRegister(adr, val);
	    switch(adr)
	    {
	      case Instructions.PC:
	        memory.setPointer(val,0);
	        break;
	      case Instructions.HP:
	        memory.setPointer(val,1);
	        break;
	      case Instructions.SP:
	        memory.setPointer(val,2);
	        break;
	    }
	  };
	  interpreter.onParsed = (List<int> program){
	    memory.loadProgram(program);
	  };
	
	  DivElement wrapper = new DivElement();
	  wrapper.append(createTitle("Source"));
	  wrapper.append(txt_source);
	  wrapper.append(createTitle("Output"));
	  wrapper.append(txt_out);
	
	  wrapper.append(createMenu());
	
	  wrapper.append(createTitle("Registers"));
	  wrapper.append(registertable.element);
	  wrapper.append(createTitle("Memory"));
	  wrapper.append(memory.element);
	  return wrapper;
	}
	
	void setSource(String src)
	{
	  txt_source.text = src;
	}
	
	Element createMenu()
	{
    //controls menu
    DivElement el_controls = new DivElement();
    el_controls.id = "controls";
  
    el_controls.append(createButton("Parse", (Event e){
      interpreter.parse(txt_source.value);
    }));
    el_controls.append(createButton("Reset", (Event e){
      interpreter.reset();
    }));
    el_controls.append(createButton("Halt", (Event e){
        interpreter.halted = true;
      }));
    el_controls.append(createButton("Step", (Event e){
        interpreter.step();
      }));
    el_controls.append(createButton("Run", (Event e){
      interpreter.timedRun(new Duration(seconds: 1));
    }));
    el_controls.append(createButton("Fast Run", (Event e){
      interpreter.run();
    }));
    return el_controls;
	}
	
	Element createButton(String label, void onData(Event event))
	{
	  ButtonElement btn = new ButtonElement();
	  btn.text = label;
	  btn.onClick.listen(onData);
	  return btn;
	}
	
	Element createTitle(String title)
	{
	  return new HeadingElement.h3()..text = title;
	}
}