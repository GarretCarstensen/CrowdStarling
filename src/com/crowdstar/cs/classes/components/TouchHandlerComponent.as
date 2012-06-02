package com.crowdstar.cs.classes.components
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.game_objects.GameObject;
	
	import flash.events.Event;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * This component class adds touch handling functionality to a game object.
	 * An event handler can be assigned in conjunction with a sprite which will
	 * listen for a touch event. The touch event is set to be handled with the
	 * given event handler.
	 * */
	public class TouchHandlerComponent extends Component
	{
		/**Starling sprite to which the touch event handler is added.*/
		private var m_sprite:Sprite;
		
		/**Touch event handler added to the assigned sprite.*/
		private var m_onTouch:Function;
		
		/**Function executed when a touch begins on the assigned sprite.
		 * This must accept a parameter of type starling.events.Touch.*/
		private var m_onTouchBegan:Function;
		
		public function TouchHandlerComponent(gameObject:GameObject, sprite:Sprite = null, onTouch:Function = null)
		{
			super(TouchHandlerComponent, gameObject);
			
			setSprite(sprite);
			
			if (onTouch != null)
			{
				setOnTouch(onTouch);
			}
			else
			{
				setOnTouch(onTouchDefault);
			}
		}
		
		/**
		 * Sets the touch event handler to be added to the assigned sprite.
		 * If the sprite is currently assigned, the previouse touch event
		 * listener is removed and a new one is added using the new touch
		 * event handler. Otherwise, only the event handler is assigned, and
		 * a touch event listener will be added once the sprite is assigned.
		 * Note that the handler must accept a parameter of Starling TouchEvent.
		 * */
		public function setOnTouch(onTouch:Function):void
		{
			if (m_onTouch != onTouch)
			{
				// Replace the current touch event handler on the sprite if it exists
				if (m_sprite)
				{
					m_sprite.removeEventListener(TouchEvent.TOUCH, m_onTouch);
					m_sprite.addEventListener(TouchEvent.TOUCH, onTouch);
				}
				
				// Assign the new touch event handler
				m_onTouch = onTouch;
			}
			else
			{
				Game.warning("Identical touch event handler is already assigned to touch handling component.");
			}
		}
		
		/**
		 * Sets the sprite to which the touch event listener is added.
		 * If another sprite is currently assigned, the touch event
		 * listener is removed from the current sprite before assigning
		 * the new sprite and adding a new touch event listener.
		 * */
		public function setSprite(sprite:Sprite):void
		{
			if (m_sprite != sprite)
			{
				// Remove any previous touch handler
				if (m_sprite)
				{
					m_sprite.removeEventListener(TouchEvent.TOUCH, m_onTouch);
				}
				
				// Assign the sprite
				m_sprite = sprite;
				
				// Add a touch event listener if the touch event handler is assigned.
				if (m_onTouch != null)
				{
					m_sprite.addEventListener(TouchEvent.TOUCH, m_onTouch);
				}
			}
			else
			{
				Game.warning("Identical sprite is already assigned to touch handling component.");
			}
		}
		
		/**
		 * This is the default touch event handler which will be added
		 * to a given sprite if no other touch event handler is assigned.
		 * */
		private function onTouchDefault(e:TouchEvent):void
		{
			//DEBUG
			//Game.log("touch detected on "+this);
			
			// Lists for sorting touch phases
			var touchesBegan:Vector.<Touch> = new Vector.<Touch>();
			var touchesMoved:Vector.<Touch> = new Vector.<Touch>();
			var touchesEnded:Vector.<Touch> = new Vector.<Touch>();
			
			var i:uint; // Touch iterator
			for (i = 0; i < e.touches.length; i++)
			{
				switch (e.touches[i].phase)
				{
					case TouchPhase.BEGAN:
						touchesBegan.push(e.touches[i]);
						break;
					case TouchPhase.MOVED:
						touchesMoved.push(e.touches[i]);
						break;
					case TouchPhase.ENDED:
						touchesEnded.push(e.touches[i]);
						break;
				}
			}
			
			// Execute handler for touches began first
			if (m_onTouchBegan != null)
			{
				for (i = 0; i < touchesBegan.length; i++)
				{
					m_onTouchBegan(touchesBegan[i]);
				}
			}
		}
		
		override public function dispose(removeFromGameObject:Boolean=true):Boolean
		{
			if (super.dispose(removeFromGameObject))
			{
				// Remove event listener and null reference to the sprite
				if (m_sprite)
				{
					m_sprite.removeEventListener(TouchEvent.TOUCH, m_onTouch);
					m_sprite = null;
				}
				
				// Null reference to touch event handlers
				m_onTouch = null;
				return true;
			}
			return false;
		}
	}
}