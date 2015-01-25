package hxE2.systems;
import hxE2.EntityWorld;

/**
 * ...
 * @author PDeveloper
 */

using Lambda;

class SystemGroup
{
	
	private var world:EntityWorld;
	private var systems:Array<System>;
	
	public function new(world:EntityWorld):Void
	{
		this.world = world;
		
		systems = new Array<System>();
	}
	
	/**
	 * Update all systems!
	 * @param	delta
	 */
	
	public inline function update(delta:Float):Void
	{
		for (system in systems)
		{
			if (system.canProcess(delta)) system.process(delta);
		}
	}
	
	/**
	 * Adds a system to this group
	 * @param	system
	 */
	
	public function add(system:System):Void
	{
		if (!systems.has(system)
		{
			systems.push(system);
			system.__onSystemAdded(world);
		}
	}
	
	/**
	 * Removes a system from this group
	 * @param	system
	 */
	
	public function remove(system:System):Void
	{
		if (systems.remove(system)) system.__onSystemRemoved();
	}
	
	/**
	 * Destroys this group, and all systems. BAM, clean up!
	 */
	
	public inline function destroy():Void
	{
		while(systems.length > 0) systems.pop().destroy();
	}
	
}