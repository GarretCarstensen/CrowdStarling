package com.crowdstar.cs.classes.components
{
	import com.crowdstar.cs.classes.game_objects.GameObject;
	import com.crowdstar.cs.classes.game_objects.World;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	
	/**
	 * This class implements functionality for placement within
	 * a world and interaction with other objects with world components.
	 * */
	public class WorldObjectComponent extends Component
	{
		// Essential positional properties
		private var m_world:World;
		private var m_x:Number;
		private var m_y:Number;
		
		// Optional movement properties
		/**Change in position to be applied.*/
		private var m_velocityX:Number;
		private var m_velocityY:Number;
		
		// Optional visual properties
		/**Sprite who's position is determined by this world object component's world position.*/
		private var m_sprite:Sprite;
		
		public function WorldObjectComponent(gameObject:GameObject, world:World, x:Number = 0, y:Number = 0)
		{
			super(WorldObjectComponent, gameObject);
			m_world = world;
			m_x = x;
			m_y = y;
		}
		
		/**
		 * Get the position of the world object component in world units.
		 * */
		public function getPosition():Point { return new Point(m_x, m_y); }
		public function getPositionX():Number { return m_x; }
		public function getPositionY():Number { return m_y; }
		
		/**
		 * Set the position of the world object component in world units.
		 * */
		public function setPosition(x:Number, y:Number):void
		{
			m_x = x;
			m_y = y;
		}
		public function setPositionX(x:Number):void
		{
			m_x = x;
		}
		public function setPositionY(y:Number):void
		{
			m_y = y;
		}
		public function setPositionWithPoint(position:Point):void
		{
			m_x = position.x;
			m_y = position.y;
			updateSpritePosition();
		}
		
		/**
		 * Get the change in position to be applied.
		 * */
		public function getVelocity():Point { return new Point(m_velocityX, m_velocityY); }
		public function getVelocityX():Number { return m_velocityX; }
		public function getVelocityY():Number { return m_velocityY; }
		
		/**
		 * Set the change in position to be applied.
		 * */
		public function setVelocity(x:Number, y:Number):void
		{
			m_velocityX = x;
			m_velocityY = y;
		}
		public function setVelocityX(x:Number):void
		{
			m_velocityX = x;
		}
		public function setVelocityY(y:Number):void
		{
			m_velocityY = y;
		}
		public function setVelocityWithPoint(velocity:Point):void
		{
			m_velocityX = velocity.x;
			m_velocityY = velocity.y;
		}
		
		/**
		 * Change the position of this world object component by the current velocity.
		 * */
		public function applyVelocity():void
		{
			setPosition(m_x + m_velocityX, m_y + m_velocityY);
		}
		
		/**
		 * Adds each component of the given point to the corresponding component.
		 * */
		public function accelerate(acceleration:Point):void
		{
			m_velocityX += acceleration.x;
			m_velocityY += acceleration.y;
		}
		
		/**
		 * Sets a sprite to be attached to this world object component. The stage
		 * position of the attached sprite remains in sync with the corresponding
		 * world position of this world object component.
		 * */
		public function attachSprite(sprite:Sprite):void
		{
			if (m_sprite && m_sprite.parent)
			{
				m_sprite.removeFromParent(true);
			}
			m_sprite = sprite;
			m_world.addSprite(m_sprite);
			updateSpritePosition();
		}
		
		public function updateSpritePosition():Boolean
		{
			if (m_sprite)
			{
				// Set sprite position
				var positionInPixels:Point = m_world.getStagePosition(getPosition());
				m_sprite.x = positionInPixels.x;
				m_sprite.y = positionInPixels.y;
				return true;
			}
			return false;
		}
		
		override public function dispose(removeFromGameObject:Boolean=true):Boolean
		{
			// Call super function to check if disposal is in progress and to set disposal flag
			if (!super.dispose(removeFromGameObject))
			{
				return false;
			}
			
			m_world = null;
			m_sprite = null;
			
			return true;
		}
	}
}