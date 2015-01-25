package hxE2;
import hxE2.bits.BitFlag;

/**
 * ...
 * @author PDeveloper
 */

@:rtti class Component
{
	
	@:allow(hxE2.core.ComponentManager)
	private var _owner:Entity;
	
	public function new() 
	{
		
	}
	
	function get_owner():Entity 
	{
		return _owner;
	}
	
	public var owner(get_owner, null):Entity;
	
}