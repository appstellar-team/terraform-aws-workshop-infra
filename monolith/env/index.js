exports.handler = async (event) => {
  // TODO implement
  const response = {
    statusCode: 200,
    headers: {
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET",
    },
    body: JSON.stringify(
      "Hello from IaC with Terraform Workshop - Test Lambda!"
    ),
  };
  return response;
};
