package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);

		#if !switch
		NGio.postScore(score, song);
		#end

		if (!FlxG.save.data.botplay)
		{
			if (songScores.exists(KadeEngineData.gameStyleName + '_' + daSong))
			{
				if (songScores.get(KadeEngineData.gameStyleName + '_' + daSong) < score)
					setScore(KadeEngineData.gameStyleName + '_' + daSong, score);
			}
			else
				setScore(KadeEngineData.gameStyleName + '_' + daSong, score);
		}
		else
			trace('BotPlay detected. Score saving is disabled.');
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0):Void
	{
		#if !switch
		NGio.postScore(score, "Week " + week);
		#end

		if (!FlxG.save.data.botplay)
		{
			var daWeek:String = formatSong('week' + week, diff);

			if (songScores.exists(KadeEngineData.gameStyleName + '_' + daWeek))
			{
				if (songScores.get(KadeEngineData.gameStyleName + '_' + daWeek) < score)
					setScore(KadeEngineData.gameStyleName + '_' + daWeek, score);
			}
			else
				setScore(KadeEngineData.gameStyleName + '_' + daWeek, score);
		}
		else
			trace('BotPlay detected. Score saving is disabled.');
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		var daSong:String = song;

		if (diff == 0)
			daSong += '-easy';
		else if (diff == 2)
			daSong += '-hard';

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);

		if (!songScores.exists(KadeEngineData.gameStyleName + '_' + daSong))
			setScore(KadeEngineData.gameStyleName + '_' + daSong, 0);

		return songScores.get(KadeEngineData.gameStyleName + '_' + daSong);
	}

	public static function getWeekScore(week:Int, diff:Int):Int
	{
		var daWeek:String = formatSong('week' + week, diff);

		if (!songScores.exists(KadeEngineData.gameStyleName + '_' + daWeek))
			setScore(KadeEngineData.gameStyleName + '_' + daWeek, 0);

		return songScores.get(KadeEngineData.gameStyleName + '_' + daWeek);
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
	}
}
