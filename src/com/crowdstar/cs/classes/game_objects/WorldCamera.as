package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.components.UpdateComponent;
	import com.crowdstar.cs.classes.components.WorldObjectComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class WorldCamera extends GameObject
	{
		private var m_worldObjectCmp:WorldObjectComponent;
		private var m_updateCmp:UpdateComponent;
		
		// Camera positionin properties
		private var m_relativeScreenPosition:Point;
		private var m_target:WorldObjectComponent;
		private var m_minX:Number;
		private var m_minY:Number;
		private var m_maxX:Number;
		private var m_maxY:Number;
		
		public function WorldCamera(world:World, relativeScreenPosition:Point = null, target:WorldObjectComponent = null)
		{
			super();
			
			// Create the world object for this camera using the initial target's position if available
			var position:Point;
			if (target)
			{
				position = target.getPosition();
			}
			else
			{
				position = new Point();
			}
			m_worldObjectCmp = new WorldObjectComponent(this, world, position.x, position.y);
			
			// Create the update component used to update camera position each frame
			m_updateCmp = new UpdateComponent(this, update);
			
			// Set the screen ratio at which this camera aligns its target's position
			if (relativeScreenPosition)
			{
				m_relativeScreenPosition = relativeScreenPosition;
			}
			else
			{
				m_relativeScreenPosition = new Point(0.5,0.5);
			}
			
			// Assign the target object
			m_target = target;
		}
		
		public function getWorldObjectCmp():WorldObjectComponent { return m_worldObjectCmp; }
		
		public function getTarget():WorldObjectComponent { return m_target; }
		public function setTarget(target:WorldObjectComponent):void
		{
			m_target = target;
		}
		
		public function getRelativeScreenPosition():Point { return m_relativeScreenPosition; }
		
		public function setPositionBounds(minX:Number, minY:Number, maxX:Number, maxY:Number):void
		{
			m_minX = minX;
			m_minY = minY;
			m_maxX = maxX;
			m_maxY = maxY;
		}
		
		public function setPositionBoundsWithRectangle(rect:Rectangle):void
		{
			m_minX = rect.x;
			m_minY = rect.y;
			m_maxX = rect.x + rect.width;
			m_maxY = rect.y + rect.height;
		}
		
		public function getPositionBounds():Rectangle
		{
			return new Rectangle(m_minX, m_minY, m_maxX - m_minX, m_maxY - m_minY);
		}
		
		public function update(dt:Number):void
		{
			if (m_target)
			{
				m_worldObjectCmp.setPositionWithPoint(m_target.getPosition());
			}
		}
		
		override public function dispose(disposeComponents:Boolean=true):Boolean
		{
			if (super.dispose(disposeComponents))
			{
				m_worldObjectCmp = null;
				m_target = null;
				m_relativeScreenPosition = null;
				return true;
			}
			return false;
		}
	}
}