exports.handler = async (event) => {
    try {
        const message = 'Hello, AWS Lambda with JavaScript!';
       
        return {
            statusCode: 200,
            body: JSON.stringify({ message, data: "hades_lobo_JS" }),
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 500,
            body: JSON.stringify({ error: 'Internal Server Error' }),
        };
    }
};
