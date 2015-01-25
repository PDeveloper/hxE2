package hxE2.core;
import hxE2.bits.BitFlag;

/**
 * ...
 * @author PDeveloper
 */

interface IComponentType
{
	
	public var id:Int;
	public var flag:BitFlag;
	
}

class ComponentType<T:Component> implements IComponentType
{
	
	public var componentClass:Class<T>;
	
	public var id:Int;
	public var flag:BitFlag;
	
	public function new( componentClass:Class<T>, id:Int ) 
	{
		this.componentClass = componentClass;
		
		this.id = id;
		
		flag = new BitFlag();
		flag.set( id + 1, 1 );
	}
	
}