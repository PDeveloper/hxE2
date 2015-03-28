package hxE2;
import hxE2.bits.BitFlag;
import hxE2.Component;
import hxE2.container.FastStorage;
import hxE2.container.SlaveContainer;
import hxE2.core.ComponentType;
import hxE2.Entity;

using Lambda;

/**
 * ...
 * @author PDeveloper
 */

class View implements IView
{
	
	private var includeFlag:BitFlag;
	private var excludeFlag:BitFlag;
	
	private var _exclude:Array<Class<Component>>;
	
	private var _entities:FastStorage<Entity>;
	private var _entityFlags:FastStorage<Bool>;
	
	private var _updates:FastStorage<Entity>;
	private var _updateFlags:FastStorage<Bool>;
	
	private var _addedEntities:FastStorage<Entity>;
	private var _updatedEntities:FastStorage<Entity>;
	private var _removedEntities:FastStorage<Entity>;
	
	private var toRemove:Array<Entity>;
	
	@:access(hxE2.EntityWorld.initializeView)
	public function new(world:EntityWorld, exclude:Array<Class<Component>> = null):Void
	{
		_exclude = (exclude != null) ? exclude : new Array<Class<Component>>();
		
		includeFlag = new BitFlag();
		excludeFlag = new BitFlag();
		
		_entities = new FastStorage<Entity>();
		_entityFlags = new FastStorage<Bool>();
		
		_updates = new FastStorage<Entity>();
		_updateFlags = new FastStorage<Bool>();
		
		_addedEntities = new FastStorage<Entity>();
		_updatedEntities = new FastStorage<Entity>();
		_removedEntities = new FastStorage<Entity>();
		
		toRemove = new Array<Entity>();
		
		for (c in _exclude) excludeFlag.set(world.components.getType(c).id + 1, 1);
		excludeFlag.flip();
		
		_initialize();
		world.initializeView(this);
	}
	
	private function _initialize():Void {}
	
	@:allow(hxE2.EntityWorld)
	private inline function push(e:Entity):Void
	{
		if (!_updateFlags.at(e.id))
		{
			_updates.push(e);
			_updateFlags.set(e.id, true);
		}
	}
	
	public function update():Void
	{
		clear();
		for (e in toRemove)
		{
			_addedEntities.remove(e);
			_updatedEntities.remove(e);
			_removedEntities.remove(e);
			
			_entities.remove(e);
			_entityFlags.set(e.id, false);
		}
		for (e in _updates)
		{
			updateEntity(e);
			_updateFlags.set(e.id, false);
		}
		_updates.clear();
	}
	
	private inline function removeEntity(e:Entity):Void
	{
		toRemove.push(e);
	}
	
	private inline function updateEntity(e:Entity):Void
	{
		if (e.flag.contains(includeFlag) && excludeFlag.contains(e.flag))
		{
			if (_entityFlags.at(e.id)) _updatedEntities.push(e);
			else
			{
				_addedEntities.push(e);
				_entities.push(e);
				_entityFlags.set(e.id, true);
			}
		}
		else if (_entityFlags.at(e.id))
		{
			_removedEntities.push(e);
			_entities.remove(e);
			_entityFlags.set(e.id, false);
		}
	}
	
	public inline function clear():Void
	{
		_addedEntities.clear();
		_updatedEntities.clear();
		_removedEntities.clear();
	}
	
	public inline function has(e:Entity):Bool
	{
		return _entityFlags.at(e.id);
	}
	
	public function dispose():Void
	{
		
	}
	
	function get_exclude():Array<Class<Component>> 
	{
		return _exclude;
	}
	
	public var exclude(get_exclude, null):Array<Class<Component>>;
	
	function get_addedEntities():FastStorage<Entity> 
	{
		return _addedEntities;
	}
	
	public var addedEntities(get_addedEntities, null):FastStorage<Entity>;
	
	function get_updatedEntities():FastStorage<Entity> 
	{
		return _updatedEntities;
	}
	
	public var updatedEntities(get_updatedEntities, null):FastStorage<Entity>;
	
	function get_removedEntities():FastStorage<Entity> 
	{
		return _removedEntities;
	}
	
	public var removedEntities(get_removedEntities, null):FastStorage<Entity>;
	
	function get_entities():FastStorage<Entity> 
	{
		return _entities;
	}
	
	public var entities(get_entities, null):FastStorage<Entity>;
	
}

class View1 <T:Component> extends View
{
	
	private var slot1:ComponentType<T>;
	private var container1:SlaveContainer<T>;
	
	public function new(world:EntityWorld, c1:Class<T>, exclude:Array<Class<Component>> = null):Void
	{
		slot1 = cast world.components.getType(c1);
		container1 = cast world.components.getContainer(slot1).getSlaveContainer(this);
		
		super(world, exclude);
	}
	
	override function _initialize():Void 
	{
		includeFlag.set(slot1.id + 1, 1);
	}
	
	public function set1(e:Entity, c:T):Void
	{
		container1.set(e, c);
	}
	
	public function remove1(e:Entity):Void
	{
		container1.remove(e);
		removeEntity(e);
	}
	
	public function get1(e:Entity):T
	{
		return container1.get(e);
	}
	
	public function has1(e:Entity):Bool
	{
		return container1.has(e);
	}
	
	override public function dispose():Void 
	{
		container1.dispose();
	}
	
}

class View2 <T:Component, U:Component> extends View1<T>
{
	
	private var slot2:ComponentType<U>;
	private var container2:SlaveContainer<U>;
	
	public function new(world:EntityWorld, c1:Class<T>, c2:Class<U>, exclude:Array<Class<Component>> = null):Void
	{
		slot2 = cast world.components.getType(c2);
		container2 = cast world.components.getContainer(slot2).getSlaveContainer(this);
		
		super(world, c1, exclude);
	}
	
	override function _initialize():Void 
	{
		super._initialize();
		includeFlag.set(slot2.id + 1, 1);
	}
	
	public function set2(e:Entity, c:U):Void
	{
		container2.set(e, c);
	}
	
	public function remove2(e:Entity):Void
	{
		container2.remove(e);
		removeEntity(e);
	}
	
	public function get2(e:Entity):U
	{
		return container2.get(e);
	}
	
	public function has2(e:Entity):Bool
	{
		return container2.has(e);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		container2.dispose();
	}
	
}

class View3<T:Component, U:Component, V:Component> extends View2<T, U>
{
	
	private var slot3:ComponentType<V>;
	private var container3:SlaveContainer<V>;
	
	public function new(world:EntityWorld, c1:Class<T>, c2:Class<U>, c3:Class<V>, exclude:Array<Class<Component>> = null):Void
	{
		slot3 = cast world.components.getType(c3);
		container3 = cast world.components.getContainer(slot3).getSlaveContainer(this);
		
		super(world, c1, c2, exclude);
	}
	
	override function _initialize():Void 
	{
		super._initialize();
		includeFlag.set(slot3.id + 1, 1);
	}
	
	public function set3(e:Entity, c:V):Void
	{
		container3.set(e, c);
	}
	
	public function remove3(e:Entity):Void
	{
		container3.remove(e);
		removeEntity(e);
	}
	
	public function get3(e:Entity):V
	{
		return container3.get(e);
	}
	
	public function has3(e:Entity):Bool
	{
		return container3.has(e);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		container3.dispose();
	}
	
}

class View4<T:Component, U:Component, V:Component, W:Component> extends View3<T, U, V>
{
	
	private var slot4:ComponentType<W>;
	private var container4:SlaveContainer<W>;
	
	public function new(world:EntityWorld, c1:Class<T>, c2:Class<U>, c3:Class<V>, c4:Class<W>, exclude:Array<Class<Component>> = null):Void
	{
		slot4 = cast world.components.getType(c4);
		container4 = cast world.components.getContainer(slot4).getSlaveContainer(this);
		
		super(world, c1, c2, c3, exclude);
	}
	
	override function _initialize():Void 
	{
		super._initialize();
		includeFlag.set(slot4.id + 1, 1);
	}
	
	public function set4(e:Entity, c:W):Void
	{
		container4.set(e, c);
	}
	
	public function remove4(e:Entity):Void
	{
		container4.remove(e);
		removeEntity(e);
	}
	
	public function get4(e:Entity):W
	{
		return container4.get(e);
	}
	
	public function has4(e:Entity):Bool
	{
		return container4.has(e);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		container4.dispose();
	}
	
}

class View5<T:Component, U:Component, V:Component, W:Component, X:Component> extends View4<T, U, V, W>
{
	
	private var slot5:ComponentType<X>;
	private var container5:SlaveContainer<X>;
	
	public function new(world:EntityWorld, c1:Class<T>, c2:Class<U>, c3:Class<V>, c4:Class<W>, c5:Class<X>, exclude:Array<Class<Component>> = null):Void
	{
		slot5 = cast world.components.getType(c5);
		container5 = cast world.components.getContainer(slot5).getSlaveContainer(this);
		
		super(world, c1, c2, c3, c4, exclude);
	}
	
	override function _initialize():Void 
	{
		super._initialize();
		includeFlag.set(slot5.id + 1, 1);
	}
	
	public function set5(e:Entity, c:X):Void
	{
		container5.set(e, c);
	}
	
	public function remove5(e:Entity):Void
	{
		container5.remove(e);
		removeEntity(e);
	}
	
	public function get5(e:Entity):X
	{
		return container5.get(e);
	}
	
	public function has5(e:Entity):Bool
	{
		return container5.has(e);
	}
	
	override public function dispose():Void 
	{
		super.dispose();
		container5.dispose();
	}
	
}