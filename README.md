# hxE2
An entity system that is evolved from hxE. This does not deprecate hxE, but rather offers a different approach to entity systems that is more in line with my own views on how one should be implemented.

# Install
`haxelib git hxE2 https://github.com/PDeveloper/hxE2.git`

# Usage
```haxe
var world = new EntityWorld();

var e = world.create();

e.setComponent(new PositionComponent());
e.setComponent(new DisplayComponent());

var view = new View2(world, PositionComponent, DisplayComponent);

while (true)
{
  view.update();
  
  for (e in view.removedEntities) remove(e); // do something with removed entities if needed
  for (e in view.addedEntities) add(e); // do something with added entities if needed
  for (e in view.updatedEntities) update(e); // do something with only updated entities if needed
  
  for (e in view.entities) func(e); // do something with all entities in the view if needed
}

function update(e:Entity):Void
{
  var position = view.get1(e);
  var display = view.get2(e);
  
  position.x += 5.0;
  view.set1(e, position); // update component
}

view.dispose(); // dispose views when they are no longer relevant / don't need to receive updates
```
