package hxE2.container;
import hxE2.Entity;

/**
 * ...
 * @author PDeveloper
 */

class FastStorageIterator<T>
{
	
	private var _storage:FastStorage<T>;
	private var _index:Int;
	
	public function new(storage:FastStorage<T>):Void
	{
		_storage = storage;
		initialize();
	}
	
	public inline function initialize():Void { _index = 0; }
	
	public inline function hasNext():Bool { return _index < _storage.length(); }
	public inline function next():T { return _storage.at(_index++); }
	
}

class FastStorage<T>
{
	
	private var _length:Int;
	private var _container:Array<T>;
	
	private var _iterator:FastStorageIterator<T>;
	
	public function new():Void
	{
		_length = 0;
		_container = new Array<T>();
		
		_iterator = new FastStorageIterator<T>(this);
	}
	
	public inline function set(index:Int, value:T):Void
	{
		_container[index] = value;
	}
	
	public inline function at(index:Int):T
	{
		return _container[index];
	}
	
	public inline function length():Int
	{
		return _length;
	}
	
	public inline function has(value:T):Bool
	{
		var i = _container.indexOf(value);
		return i >= 0 && i < _length;
	}
	
	public inline function push(value:T):Void
	{
		_container[_length++] = value;
	}
	
	public inline function pop():T
	{
		if (_length == 0) return null;
		else return _container[_length--];
	}
	
	public inline function remove(value:T):Bool
	{
		return _container.remove(value);
	}
	
	public inline function clear():Void
	{
		_length = 0;
	}
	
	public inline function iterator():FastStorageIterator<T>
	{
		_iterator.initialize();
		return _iterator;
	}
	
}