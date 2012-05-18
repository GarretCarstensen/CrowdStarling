package classes.game_objects
{
	
	public class WorldCell extends GameObject
	{
		private var m_x:uint;
		private var m_y:uint;
		private var m_effects:Vector.<WorldCellEffect>;
		
		public function WorldCell(x:uint, y:uint)
		{
			super();
			
			m_x = x;
			m_y = y;
			m_effects = new Vector.<WorldCellEffect>();
		}
		
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
		
		override public function dispose():Boolean
		{
			while(m_effects.length)
			{
				var effect:WorldCellEffect = m_effects.pop();
				effect.dispose();
			}
			return true;
		}
	}
}