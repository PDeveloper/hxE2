package hxE2;

using Lambda;

/**
 * ...
 * @author PDeveloper
 */

class EntitySystem
{
	
	public var id:Int;
	
	private var _world:EntityWorld;
	
	private var isPassive:Bool;
	
	public function new() 
	{
		isPassive = false;
	}
	
	@:final
	@:allow( hxE2.EntityWorld )
	private function __onSystemAdded( world:EntityWorld ):Void
	{
		_world = world;
		onSystemAdded( world );
	}
	
	public function onSystemAdded( world:EntityWorld ):Void
	{
		
	}
	
	@:final
	@:allow( hxE2.EntityWorld )
	private function __onSystemRemoved():Void
	{
		onSystemRemoved();
		_world = null;
	}
	
	public function onSystemRemoved():Void
	{
		
	}
	
	@final
	public function __process( timeStep:Float ):Void
	{
		process( timeStep );
	}
	
	/**
	 * Proccesses all entities!
	 * @param	entitiesToProcess
	 */
	
	public function process( timeStep:Float ):Void
	{
		
	}
	
	@final
	public function canProcess( timeStep:Float ):Bool
	{
		return !isPassive && checkProcessing( timeStep );
	}
	
	@final
	public function setPassive( isPassive:Bool):Void
	{
		this.isPassive = isPassive;
	}
	
	@final
	public function getPassive():Bool
	{
		return isPassive;
	}
	
	/**
	 * Returns if this entity system should process!
	 * @return
	 */
	
	public function checkProcessing( timeStep:Float ):Bool
	{
		return true;
	}
	
	/**
	 * Called when this system is destroyed
	 */
	
	public function destroy():Void
	{
		
	}
	
	private function get_world():EntityWorld 
	{
		return _world;
	}
	
	public var world(get_world, null):EntityWorld;
	
}