exports.handler = async (event) => {
  // TODO implement
  const response = {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json",
      "Access-Control-Allow-Headers": "Content-Type",
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET",
    },
    body: JSON.stringify({
      message: "Hello from IaC with Terraform Workshop - Test Lambda!",
    }),
  };
  return response;
};
