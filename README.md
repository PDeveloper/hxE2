# hxE2
A lean Entity System.

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
  
  for (e in view.removedEntities) remove(e);
  for (e in view.addedEntities) add(e);
  for (e in view.updatedEntities) update(e);
}

function update(e:Entity):Void
{
  var position = view.get1(e);
  var display = view.get2(e);
  
  position.x += 5.0;
  view.set1(e, position); // update component
}
```
