import com.rabbitmq.client.ConnectionFactory;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.Channel;

public class Send 
{
	private final static String QUEUE_NAME = "hello";

	public static voice main(String[] argv)
    	throws java.io.IOException 
      	{
 			ConnectionFactory factory = new ConnectionFactory();
    		factory.setHost("localhost");
    		Connection connection = factory.newConnection();
    		Channel channel = connection.createChannel();
      	}
}