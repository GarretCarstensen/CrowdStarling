package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.components.WorldObjectComponent;
	
	import flash.geom.Point;
	
	public class WorldCell extends GameObject
	{
		private var m_worldObjectCmp:WorldObjectComponent;
		private var m_effects:Vector.<WorldCellEffect>;
		
		public function WorldCell(world:World, x:Number = 0, y:Number = 0)
		{
			super();
			
			m_worldObjectCmp = new WorldObjectComponent(this, world, x, y);
			m_effects = new Vector.<WorldCellEffect>();
		}
		
		public function getWorldObjectCmp():WorldObjectComponent { return m_worldObjectCmp; }
		
		/**
		 * World cells update via the update loop in the world class rather
		 * than including an UpdateComponent.
		 * */
		public function update(dt:int):void { }
		
		public function addEffect(effect:WorldCellEffect):void
		{
			m_effects.push(effect);
			effect.setCell(this);
		}
		
		public function removeEffect(effect:WorldCellEffect):void
		{
			var index:int = m_effects.indexOf(effect);
			if (index != -1)
			{
				m_effects.splice(index, 1);
				effect.setCell(null);
			}
		}
		
		override public function dispose(disposeComponents:Boolean = true):Boolean
		{
			if (super.dispose(disposeComponents))
			{
				while(m_effects.length)
				{
					var effect:WorldCellEffect = m_effects.pop();
					effect.dispose(true);
				}
				return true;
			}
			return false;
		}
	}
}