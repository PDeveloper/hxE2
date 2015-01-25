package hxE2;

import hxE2.core.ComponentManager;
import hxE2.core.EntityManager;

/**
 * ...
 * @author PDeveloper
 */

class EntityWorld
{
	
	public var entities:EntityManager;
	public var components:ComponentManager;
	
	public function new():Void
	{
		entities = new EntityManager(this);
		components = new ComponentManager();
	}
	
	/**
	 * Create a new entity!
	 * @return
	 */
	
	public inline function create():Entity
	{
		return entities.create();
	}
	
	/**
	 * Destroys all entities!
	 */
	
	public inline function destroy():Void
	{
		entities.destroyAll();
	}
	
	/**
	 * Destroy an entity
	 * @param	e
	 */
	
	public inline function destroyEntity(e:Entity):Void
	{
		entities.destroy(e);
	}
	
	private inline function initializeView(view:IView):Void
	{
		for (e in entities.getUsedEntities()) view.push(e);
	}
	
}