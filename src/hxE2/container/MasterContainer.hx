package hxE2.container;
import hxE2.Component;
import hxE2.core.ComponentManager;
import hxE2.core.ComponentType;
import hxE2.Entity;
import hxE2.View.IView;

using Lambda;

/**
 * ...
 * @author PDeveloper
 */

class MasterContainer<T:Component> implements IMasterContainer
{
	
	private var _manager:ComponentManager;
	
	private var _type:ComponentType<T>;
	private var _array:Array<T>;
	
	private var _slaves:Array<SlaveContainer<T>>;
	
	public function new(type:ComponentType<T>, manager:ComponentManager):Void
	{
		_type = type;
		_manager = manager;
		
		_array = new Array<T>();
		_slaves = new Array<SlaveContainer<T>>();
	}
	
	private inline function _set(e:Entity, c:T):Void
	{
		if (c != null) e.flag.add(_type.flag);
		else e.flag.sub(_type.flag);
		_array[e.id] = c;
	}
	
	@:allow(hxE2.container.SlaveContainer)
	private inline function slaveSet(slave:SlaveContainer<T>, e:Entity, c:T):Void
	{
		_set(e, c);
		notify(e, c, slave);
	}
	
	private inline function notify(e:Entity, c:T, slave:SlaveContainer<T> = null):Void
	{
		for (i in 0..._slaves.length) if (_slaves[i] != slave) _slaves[i].masterSet(e, c);
	}
	
	public inline function set(e:Entity, c:T):Void
	{
		_set(e, c);
		notify(e, c);
	}
	
	public inline function get(e:Entity):T
	{
		return _array[e.id];
	}
	
	public inline function filter(f:T->Bool):Array<T>
	{
		return _array.filter(f);
	}
	
	public function getAll(preserveIndex:Bool = false):Array<T>
	{
		if (preserveIndex) return _array.copy();
		else return _array.filter(function (c:T):Bool { return c != null; });
	}
	
	public inline function has(e:Entity):Bool 
	{
		return _array[e.id] != null;
	}
	
	public inline function remove(e:Entity):Void 
	{
		set(e, null);
	}
	
	public inline function setComponent(e:Entity, c:Component):Void 
	{
		set(e, cast c);
	}
	
	public inline function getComponent(e:Entity):Component 
	{
		return _array[e.id];
	}
	
	public function getSlaveContainer(view:IView):IContainer
	{
		var c = new SlaveContainer<T>(view, this);
		_slaves.push(c);
		return c;
	}
	
	public function getSlave(view:IView):SlaveContainer<T>
	{
		var c = new SlaveContainer<T>(view, this);
		_slaves.push(c);
		return c;
	}
	
	@:allow(hxE2.container.SlaveContainer)
	private function disposeSlave(slave:SlaveContainer<T>):Void
	{
		_slaves.remove(slave);
	}
	
	function get_type():ComponentType<T> 
	{
		return _type;
	}
	
	public var type(get_type, null):ComponentType<T>;
	
	function get_array():Array<T> 
	{
		return _array;
	}
	
	public var array(get_array, null):Array<T>;
	
}