CrowdStarling
=============

CrowdStarling is an AS3 Library for projects using the Starling framework. It includes base classes for a component-based 2d game engine, which allows for fast and convenient implementation of a variety of game systems and mechanics. If the concept of "component-based" architecture is new to you, here is an article that explains it quite well: http://cowboyprogramming.com/2007/01/05/evolve-your-heirachy/. The goal of CrowdStarling is to provide an engine with the necessary base classes to quickly prototype, or fully develop, almost any application which the Starling AS3 framework is able to support.


Setup
=====

Pre-Requisites
--------------
The CrowdStarling library relies on the Starling AS3 library, which can be acquired from the following GitHub repository.
https://github.com/PrimaryFeather/Starling-Framework

I also recommend the tool, Hi-ReS-Stats, for tracking frame rate and memory usage with your application. Hi-ReS-Stats can be downloaded from this GitHub repository.
https://github.com/mrdoob/Hi-ReS-Stats.git

Link Source Libraries
---------------------
You can use CrowdStarling with a variety of AS3 projects, including a Flex Mobile Project in Flash Builder 4.6.
Begin by creating a new project.  Link the CrowdStarling library in your project's source folders, as well as the src folders for Starling and Hi-ReS-Stats.

Startup Code
------------
From there you will just need to place some initialization code in a function that is run at the start of your application.  Here is a sample of startup ActionScript 3 code from the "HomeView" class of a view-based Flex Mobile Project.

			import com.crowdstar.cs.classes.Game;
			import com.crowdstar.hs.classes.YourGame; // Your custom game class which extends the CrowdStarling Game class
			
			import flash.display3D.Context3DRenderMode;
			
			import mx.events.FlexEvent;
			
			import net.hires.debug.Stats;
			
			import starling.core.Starling;
			
			private var stats:Stats;
			private var mStarling:Starling;
			
			protected function creationCompleteHandler(event:FlexEvent):void
			{
				// Initialize Hi-ReS-Stats
				stats = new Stats();
				stats.alpha = 0.5;
				systemManager.stage.addChild(stats);
				
				// Starling pre-init properties
				Starling.multitouchEnabled = true;
				Starling.handleLostContext = true;
				
				// Initailize starling framework
				// Pass your custom game class which extends the CrowdStarling Game class as an arguement of this constructor.
				mStarling = new Starling(YourGame, systemManager.stage, null, null, Context3DRenderMode.SOFTWARE);
				
				// Starling post-init properties
				mStarling.antiAliasing = 1;
				mStarling.simulateMultitouch = true;
				mStarling.enableErrorChecking = false;
				
				mStarling.start();
			}