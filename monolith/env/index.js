exports.handler = async (event) => {
    // TODO implement
    const response = {
      statusCode: 200,
      body: JSON.stringify("Hello from IaC with Terraform Workshop - Test Lambda!"),
    };
    return response;
  };
  