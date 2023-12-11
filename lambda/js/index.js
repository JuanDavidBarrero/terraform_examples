exports.handler = async (event) => {
    try {
        const message = 'Hello, AWS Lambda with JavaScript!';
        console.log(message);

        const response = await fetch('https://jsonplaceholder.typicode.com/todos/1');
        const responseData = await response.json();

        console.log('Fetch response:', responseData);

        return {
            statusCode: 200,
            body: JSON.stringify({ message, data: responseData }),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};
