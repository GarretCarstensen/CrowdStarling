package classes.components
{
	import classes.Game;
	
	import flash.utils.Dictionary;
	
	import classes.game_objects.GameObject;
	
	public class UpdateComponent extends Component
	{
		private var m_callback:Function;
		private var m_priority:int;
		private var m_enabled:Boolean;
		
		public function UpdateComponent(gameObject:GameObject, callback:Function = null, priority:int = 0)
		{
			super(gameObject);
			
			m_callback = callback;
			m_priority = priority;
			m_enabled = true;
			Game.getInstance().registerUpdateComponent(this);
		}
		
		public function get priority():int { return m_priority; }
		
		public function setCallback(callback:Function):void
		{
			m_callback = callback;
		}
		
		public function getEnabled():Boolean { return m_enabled; }
		public function setEnabled(enabled:Boolean):void
		{
			m_enabled = enabled;
		}
		
		public function update(dt:int):Boolean
		{
			if (m_callback != null && m_enabled)
			{
				m_callback.call(null, [dt]);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		override public function dispose(removeFromGameObject:Boolean = true):Boolean
		{
			// Call super function to check if disposal is in progress and to set disposal flag
			if (!super.dispose(removeFromGameObject))
			{
				return false;
			}
			
			Game.getInstance().unregisterUpdateComponent(this);
			return true;
		}
	}
	
}