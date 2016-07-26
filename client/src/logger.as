package 
{
	import com.qb9.flashlib.logs.ConsoleAppender;
	import com.qb9.flashlib.logs.Logger;
	
	public const logger:Logger = Logger.getLogger('usuhaia');
	logger.addAppender(new ConsoleAppender);
	
}