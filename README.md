# EC2AmplifyGroup
Separates EC2 and Amplify permissions

This improved policy:

Separates EC2 and Amplify permissions into distinct statement blocks for better organization and management
Adds essential Amplify branch and deployment permissions that administrators would likely need
Includes necessary permissions for Amplify to interact with related services like CloudFront and S3
Restricts the iam:PassRole permission with a condition that only allows passing roles to the Amplify service
For even better security in a production environment, you should:

Further restrict resources by specifying ARNs instead of using "*" where possible
Consider creating separate policies for read-only vs. write operations
Implement additional guardrails like requiring MFA for sensitive operations
Regularly audit and review permissions usage
