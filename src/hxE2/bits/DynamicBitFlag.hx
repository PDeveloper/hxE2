package hxE2.bits;

/**
 * ...
 * @author PDeveloper
 */

class DynamicBitFlag
{
	
	private var bitLength:Int;
	
	private var fields:Array<Int>;
	
	private var size:Int;

	public function new() 
	{
		fields = new Array<Int>();
		
		size = 0;
		setSize( 1);
	}
	
	public inline function flip():Void
	{
		for (i in 0...fields.length) fields[i] = ~fields[i];
	}
	
	public inline function set(bit:Int, value:Int):Void
	{
		bit -= 1;
		var _field:Int = bit >> 5;
		var _bit:Int = bit - (_field << 5);
		
		if (_field + 1 > size) size = _field + 1;
		
		fields[_field] |= value << _bit;
	}
	
	public inline function setTrue(bit:Int):Void
	{
		bit -= 1;
		var _field:Int = bit >> 5;
		var _bit:Int = bit - (_field << 5);
		
		if (_field + 1 > size) size = _field + 1;
		
		fields[_field] |= 1 << _bit;
	}
	
	public inline function setFalse(bit:Int):Void
	{
		bit -= 1;
		var _field:Int = bit >> 5;
		var _bit:Int = bit - (_field << 5);
		
		if (_field + 1 > size) size = _field + 1;
		
		fields[_field] &= ~(1 << _bit);
	}
	
	public inline function get(bit:Int):Int
	{
		bit -= 1;
		var _field:Int = bit >> 5;
		var _bit:Int = bit - (_field << 5);
		
		if (_field + 1 > size) size = _field + 1;
		
		return (fields[_field] >> _bit) & 1;
	}
	
	public inline function add(bits:DynamicBitFlag):DynamicBitFlag
	{
		var len:Int = Std.int(Math.min(size, bits.size));
		
		for (i in 0...len)
		{
			fields[i] |= bits.fields[i];
		}
		
		return this;
	}
	
	public inline function sub(bits:DynamicBitFlag):DynamicBitFlag
	{
		var len:Int = Std.int(Math.min(size, bits.size));
		
		for (i in 0...len)
		{
			fields[i] &= ~bits.fields[i];
		}
		
		return this;
	}
	
	public inline function contains(bits:DynamicBitFlag):Bool
	{
		var len:Int = Std.int(Math.min( size, bits.size));
		
		for (i in 0...len)
		{
			if ((fields[i] & bits.fields[i]) != bits.fields[i])
			{
				return false;
			}
		}
		
		for (i in len...bits.getSize())
		{
			if (bits.fields[i] > 0)
			{
				return false;
			}
		}
		
		return true;
	}
	
	public inline function equals(bits:DynamicBitFlag):Bool
	{
		var biggest:DynamicBitFlag;
		var smallest:DynamicBitFlag;
		var len:Int;
		
		if (bits.getSize() > size)
		{
			biggest = bits;
			smallest = this;
			len = bits.getSize();
		}
		else
		{
			biggest = this;
			smallest = bits;
			len = size;
		}
		
		for (i in 0...smallest.getSize())
			if (fields[i] != bits.fields[i])
			{
				return false;
			}
		
		for (i in smallest.getSize()...biggest.getSize())
			if (biggest.fields[i] > 0)
			{
				return false;
			}
		
		return true;
	}
	
	public inline function reset():Void
	{
		for (i in 0...fields.length) fields[i] = 0;
	}
	
	public inline function getSize():Int
	{
		return size;
	}
	
	public inline function setSize(newSize:Int):Void
	{
		for (i in size...newSize) fields[i] = 0;
		size = newSize;
		
		bitLength = 32 * newSize;
	}
	
	public inline function toString():String
	{
		var output = "";
		for (field in fields)
		{
			for (i in 0...32)
			{
				output = Std.string((field >> i) & 1) + output;
			}
		}
		return output;
	}
	
}