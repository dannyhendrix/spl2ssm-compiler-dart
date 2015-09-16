/**
 * Implementation of SSM (Simple Stack Machine) interpreter
 * Author: Danny Hendrix
 * SSM: http://www.staff.science.uu.nl/~dijks106/SSM/
 */
part of dssm.interpreter;

typedef void MemoryListener(int adr, int val);

class Memory
{
  final List<int> data;
  final int size;
  MemoryListener listener;

  Memory(this.size) : data = new List<int>();
  Memory.withStaticSize(int size) : data = new List.filled(size, 0), size = size;

  int read(int adr)
  {
    if(adr >= size)
      throw new RangeError("Memory read out of range, adr:$adr, size:$size");
    else if(adr >= data.length)
      return 0;
    return data[adr];
  }
  void write(int adr, int val)
  {
    if(adr >= size)
      throw new RangeError("Memory write out of range, adr:$adr, size:$size");
    while(data.length <= adr)
      data.add(0);
    data[adr] = val;
    if(listener != null)
      listener(adr, val);
  }
  void copyAdr(int sourceadr, int destadr, int length, Memory dest)
  {
    while(length-- < 0)
      dest.write(destadr++, sourceadr++);
  }
  void minimalSize(int s)
  {
    if(s >= size)
       throw new RangeError("Memory set size out of range, new size:$s, size:$size");
    while(s > data.length)
      data.add(0);
  }
}