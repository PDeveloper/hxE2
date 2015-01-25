package hxE2;
import hxE2.bits.BitFlag;
import hxE2.core.EntityId;
import hxE2.core.ComponentType;

/**
 * ...
 * @author PDeveloper
 */

class Entity
{
	
	public var uuid:EntityId;
	public var id:Int;
	public var flag:BitFlag;
	
	private var _isActive:Bool;
	
	public var world:EntityWorld;
	
	@:allow(hxE2.core.EntityManager)
	private function new(uuid:EntityId, id:Int, world:EntityWorld):Void
	{
		this.uuid = uuid;
		this.id = id;
		
		this.world = world;
		
		flag = new BitFlag();
	}
	
	/**
	 * Add a component if it doesn't exist already.
	 * @param	component The component to add.
	 */
	
	public inline function setComponent(component:Component):Void
	{
		world.components.setComponent(this, component);
	}
	
	/**
	 * Check if this entity has the component class.
	 * @param	componentClass The component class.
	 * @return true if it has this component class
	 */
	
	public inline function hasComponent(componentClass:Class<Component>):Bool
	{
		return world.components.hasComponentClass(this, componentClass);
	}
	
	/**
	 * Check if this entity has the component type.
	 * @param	type The component type.
	 * @return true if it has this component type
	 */
	
	public inline function hasComponentType(type:IComponentType):Bool
	{
		return world.components.hasComponentType(this, type);
	}
	
	/**
	 * Get an iterator of all components owned by this entity.
	 * @return
	 */
	
	public inline function getComponents():Array<Component>
	{
		return world.components.getEntityComponents(this);
	}
	
	/**
	 * Get the type of component owned by this entity.
	 * @param	componentClass The component type you wish to retrieve.
	 * @return
	 */
	
	public inline function getComponent(componentClass:Class<Component>):Component
	{
		return world.components.getComponentByClass(this, componentClass);
	}
	
	public inline function getComponentByType(componentType:IComponentType):Component
	{
		return world.components.getComponentByType(this, componentType);
	}
	
	/**
	 * Remove component from this entity.
	 * @param	component
	 */
	
	public inline function removeComponent(component:Component):Void
	{
		world.components.removeComponentByClass(this, Type.getClass(component));
	}
	
	/**
	 * Removes the component by type of component rather than reference.
	 * @param	componentClass
	 */
	
	public inline function removeComponentByClass(componentClass:Class<Component>):Void
	{
		world.components.removeComponentByClass(this, componentClass);
	}
	
	public inline function removeComponentByType(componentType:IComponentType):Void
	{
		world.components.removeComponentByType(this, componentType);
	}
	
	/**
	 * Destroy this entity!
	 */
	
	public inline function destroy():Void
	{
		world.destroyEntity(this);
	}
	
}