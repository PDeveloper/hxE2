package hxE2;

import hxE2.core.ComponentManager;
import hxE2.core.EntityManager;
import hxE2.View;
import haxe.ds.GenericStack;

/**
 * ...
 * @author PDeveloper
 */

class EntityWorld
{
	
	public var views:Array<IView>;
	
	public var entities:EntityManager;
	public var components:ComponentManager;
	
	private var systems:Array<EntitySystem>;
	
	private var system_id:Int;
	private var system_ids:Array<Int>;
	
	public function new() 
	{
		views = new Array<IView>();
		
		entities = new EntityManager(this);
		components = new ComponentManager();
		
		systems = new Array<EntitySystem>();
		
		system_id = 0;
		system_ids = new Array<Int>();
	}
	
	/**
	 * Update all systems!
	 * @param	timeStep
	 */
	
	public inline function update(timeStep:Float):Void
	{
		for (system in systems)
		{
			if (system.canProcess(timeStep)) system.process(timeStep);
		}
	}
	
	/**
	 * Create a new entity!
	 * @return
	 */
	
	public inline function create():Entity
	{
		return entities.create();
	}
	
	private inline function getSystemId():Int
	{
		if (system_ids.length > 0) return system_ids.pop();
		else return system_id++;
	}
	
	private inline function freeSystemId(id:Int):Void
	{
		system_ids.push(id);
	}
	
	/**
	 * Adds a system to this world
	 * @param	system
	 */
	
	public function add(system:EntitySystem):Void
	{	
		systems.push(system);
		system.id = getSystemId();
		
		system.__onSystemAdded(this);
	}
	
	/**
	 * Removes a system from this world
	 * @param	system
	 */
	
	public function remove(system:EntitySystem):Void
	{
		if (systems.remove(system))
		{
			freeSystemId(system.id);
			system.__onSystemRemoved();
		}
	}
	
	/**
	 * Destroys all entities!
	 */
	
	public inline function destroyEntities():Void
	{
		entities.destroyAll();
	}
	
	/**
	 * Destroys this world, all systems, and all entities. BAM, clean up!
	 */
	
	public inline function destroy():Void
	{
		while(systems.length > 0) systems.pop().destroy();
		destroyEntities();
	}
	
	/**
	 * Destroy an entity
	 * @param	e
	 */
	
	public inline function destroyEntity(e:Entity):Void
	{
		entities.destroy(e);
	}
	
	private inline function initializeView(view:View):Void
	{
		for (e in entities.getUsedEntities()) view.push(e);
	}
	
}