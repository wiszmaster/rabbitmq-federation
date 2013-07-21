<cfscript>
	QueueName = "QTransactions";
	durable = true;
 
	loadPaths = arrayNew(1);
	loadPaths[1] = expandPath("lib/rabbitmq-java-client-bin-3.1.3/rabbitmq-client.jar");
 
	// load jars
	javaLoader = createObject("component", "lib.javaloader.JavaLoader").init(loadPaths);
 
	// Create factory
	factory = javaloader.create("com.rabbitmq.client.ConnectionFactory").init();
	factory.setHost("192.168.40.10"); 
 
	// Create properties
	messageProperties = javaloader.create("com.rabbitmq.client.MessageProperties").init();
	props = messageProperties.PERSISTENT_TEXT_PLAIN;
 
	// Connect
	connection = factory.newConnection();
	channel = connection.createChannel();
 
	// Declare queue
	channel.QueueDeclare(QueueName, durable, false, false, createJavaNull());
 
	// Create string
	objStringByteArray = createByteArray("this is my CF message 12345");
 
	// Publish
	try{
		channel.basicPublish("", QueueName, props, objStringByteArray);
	}
	finally{
		// Close connection
		channel.close();
		connection.close();	
	}
</cfscript>

