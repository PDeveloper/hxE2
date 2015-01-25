package hxE2.container;
import hxE2.core.ComponentType;
import hxE2.Entity;
import hxE2.View.IView;

/**
 * ...
 * @author PDeveloper
 */

class SlaveContainer<T:Component> implements IContainer
{
	
	public var view:IView;
	public var master:MasterContainer<T>;
	
	public function new(view:IView, master:MasterContainer<T>):Void
	{
		this.view = view;
		this.master = master;
	}
	
	@:allow(hxE2.container.MasterContainer)
	private inline function masterSet(e:Entity, c:T):Void
	{
		view.push(e);
	}
	
	public inline function set(e:Entity, c:T):Void
	{
		master.slaveSet(this, e, c);
	}
	
	public inline function get(e:Entity):T
	{
		return master.get(e);
	}
	
	public inline function filter(f:T->Bool):Array<T>
	{
		return master.filter(f);
	}
	
	public inline function getAll(preserveIndex:Bool = false):Array<T>
	{
		return master.getAll(preserveIndex);
	}
	
	public inline function has(e:Entity):Bool 
	{
		return master.has(e);
	}
	
	public inline function remove(e:Entity):Void 
	{
		master.remove(e);
	}
	
	public inline function setComponent(e:Entity, c:Component):Void 
	{
		set(e, cast c);
	}
	
	public inline function getComponent(e:Entity):Component 
	{
		return master.getComponent(e);
	}
	
	public function dispose():Void
	{
		master.disposeSlave(this);
	}
	
	function get_type():ComponentType<T> 
	{
		return master.type;
	}
	
	public var type(get_type, null):ComponentType<T>;
	
}