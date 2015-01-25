package hxE2.core;
import hxE2.bits.BitFlag;
import hxE2.Component;
import hxE2.container.IMasterContainer;
import hxE2.container.MasterContainer;
import hxE2.container.IContainer;
import hxE2.core.ComponentType;
import hxE2.Entity;

/**
 * ComponentManager of an EntityWorld. Stores and manages all components relating to all entities,
 * also holds the ComponentTypes.
 * @author PDeveloper
 */

class ComponentManager
{
	
	public var onComponentSet:Entity->Component->Void;
	
	private var currentTypeId:Int;
	private var componentTypes:Map<String , IComponentType>;
	
	private var containers:Array<IMasterContainer>;
	
	public function new()
	{
		currentTypeId = 0;
		componentTypes = new Map<String,IComponentType>();
		containers = new Array<IMasterContainer>();
	}
	
	public inline function getContainer(t:IComponentType):IMasterContainer
	{
		return containers[t.id];
	}
	
	/**
	 * Add a component to the given entity.
	 * @param	e the entity
	 * @param	c the component
	 */
	
	public inline function setComponent(e:Entity, c:Component):Void
	{
		var t = getType(Type.getClass(c));
		setComponentType(e, c, t);
	}
	
	/**
	 * Add a component by type. Unsafe! (But faster)
	 * @param	e the entity
	 * @param	c the component
	 * @param	t the component type
	 */
	
	public function setComponentType(e:Entity, c:Component, t:IComponentType):Void
	{
		containers[t.id].setComponent(e, c);
		c._owner = e;
		
		if (onComponentSet != null) onComponentSet(e, c);
	}
	
	/**
	 * Checks to see if an entity has a component by Class<Component>
	 * @param	e the entity
	 * @param	c the component class
	 * @return true if the entity has the component already
	 */
	
	public inline function hasComponentClass(e:Entity, c:Class<Component>):Bool
	{
		var t = getType(c);
		return hasComponentType(e, t);
	}
	
	/**
	 * Checks to see if an entity has a component by component type
	 * @param	e the entity
	 * @param	t the component type
	 * @return true if the entity has the component already
	 */
	
	public inline function hasComponentType(e:Entity, t:IComponentType):Bool
	{
		var components = containers[t.id];
		
		return components.has(e);
	}
	
	/**
	 * Get a component from the entity by Class<Component>
	 * @param	e the entity
	 * @param	componentClass the component class
	 * @return the component
	 */
	
	public inline function getComponentByClass(e:Entity, componentClass:Class<Component>):Component
	{
		var t = getType(componentClass);
		
		return getComponentByType(e, t);
	}
	
	/**
	 * Get a component from the entity by component type
	 * @param	e the entity
	 * @param	t the component type
	 * @return the component
	 */
	
	public inline function getComponentByType(e:Entity, t:IComponentType):Component
	{
		var components = containers[t.id];
		return components.getComponent(e);
	}
	
	/**
	 * Remove a component from an entity by Class<Component>
	 * @param	e the entity
	 * @param	c the component class
	 */
	
	public inline function removeComponentByClass(e:Entity, c:Class<Component>):Void
	{
		var t = getType(c);
		removeComponentByType(e, t);
	}
	
	/**
	 * Remove a component from an entity by component type
	 * @param	e the entity
	 * @param	t the component type
	 */
	
	public function removeComponentByType(e:Entity, t:IComponentType):Void
	{
		var components = containers[t.id];
		
		if (onComponentSet != null) onComponentSet(e, null);
		
		components.getComponent(e)._owner = null;
		components.remove(e);
	}
	
	/**
	 * Get all components for an entity.
	 * @param	e the entity
	 * @return an iterator of all components
	 */
	
	public inline function getEntityComponents(e:Entity):Array<Component>
	{
		var l = new Array<Component>();
		for (components in containers)
		{
			if (components.has(e)) l.push(components.getComponent(e));
		}
		
		return l;
	}
	
	/**
	 * Get the component type for a given class.
	 * @param	componentClass the component class
	 * @return the component type
	 */
	
	public function getType <T:Component> (componentClass:Class<T>):IComponentType
	{
		var type:IComponentType;
		var className = Type.getClassName(componentClass);
		
		if (componentTypes.exists(className))
		{
			type = componentTypes.get(className);
		}
		else
		{
			var stype = new ComponentType(componentClass, currentTypeId);
			type = stype;
			containers[currentTypeId] = new MasterContainer(stype, this);
			currentTypeId++;
			componentTypes.set(className, type);
		}
		
		return type;
	}
	
}