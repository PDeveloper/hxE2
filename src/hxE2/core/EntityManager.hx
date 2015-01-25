package hxE2.core;
import hxE2.Entity;
import hxE2.EntityWorld;
import haxe.ds.GenericStack;

using Lambda;

/**
 * ...
 * @author PDeveloper
 */

class EntityManager
{
	
	/**
	 * Pool entities.
	 */
	
	public var onEntityCreated:Entity->Void;
	public var onEntityDestroyed:Entity->Void;
	
	private var freeEnt:GenericStack<Entity>;
	private var usedEnt:GenericStack<Entity>;
	
	private var nextId:Int;
	
	private var world:EntityWorld;
	
	public function new(world:EntityWorld):Void
	{
		freeEnt = new GenericStack<Entity>();
		usedEnt = new GenericStack<Entity>();
		
		nextId = 0;
		
		this.world = world;
	}
	
	private inline function getNextId():Int
	{
		var nid = nextId;
		nextId++;
		return nid;
	}
	
	public inline function destroyAll():Void
	{
		for (e in usedEnt) destroy(e);
	}
	
	public function create():Entity
	{
		var e:Entity;
		var id = getNextId();
		var eid = new EntityId(id);
		if (freeEnt.isEmpty())
		{
			e = new Entity(eid, id, world);
		}
		else
		{
			e = freeEnt.pop();
			e.uuid = eid;
		}
		
		usedEnt.add(e);
		
		if (onEntityCreated != null) onEntityCreated(e);
		
		return e;
	}
	
	public inline function getUsedEntities():List<Entity>
	{
		return usedEnt.list();
	}
	
	public function destroy(e:Entity):Void
	{
		var components = e.getComponents();
		
		for (component in components) e.removeComponent(component);
		
		if (onEntityDestroyed != null) onEntityDestroyed(e);
		
		usedEnt.remove(e);
		freeEnt.add(e);
	}
	
}