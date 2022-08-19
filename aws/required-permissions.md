# User permissions for deployment

The user that will make the deployment need to have specific permissions to execute the deployment. In the file [FSS-user-permissions.json](FSS-user-permissions.json) you can find the specific permissions that the user policy need to have to deploy the cloudformations templates. If your current user already have a more permissive policy such as `AdministratorAccess` the deployment will work, but we do recommend to apply the principle of least privilege.

# Permissions required by the templates

The templates will create a few IAM roles and policies in order to work properly.
Also, the templates will create management roles for Cloud One File Storage Security to manage the deployed resources.
Check out the templates directly for more information.

> **Note:** It's not the permissions required to deploy the templates.

## Permissions required by scanner stack

| Permission | Type | Description |
| --- | --- | --- |
| [AWSLambdaBasicExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole$jsonEditor) | Managed Policy | Provides write permissions for a Lambda function to CloudWatch Logs. |
| `cloudformation:DescribeStacks` | Action | Describe the stacks created by Cloud One File Storage Security. |
| `cloudformation:CreateChangeSet` | Action | Creates a list of changes that will be applied to a stack so that you can review the changes before executing them |
| `cloudformation:ListStackResources` | Action | Allow Cloud One File Storage Security to list the deployed resources. |
| `cloudformation:DescribeStacks` | Action | Allow Cloud One File Storage Security to describe the deployed stacks. |
| `cloudformation:DescribeStackEvents` | Action | Allow Cloud One File Storage Security to describe the stack events. |
| `cloudformation:DescribeStackResources` | Action | Allow Cloud One File Storage Security to describe the deployed resources. |
| `cloudformation:DescribeStackResource` | Action | Allow Cloud One File Storage Security to describe the deployed resources. |
| `cloudformation:DetectStackDrift` | Action | Allow Cloud One File Storage Security to detect the drift of the deployed stack. |
| `cloudformation:DetectStackResourceDrift` | Action | Allow Cloud One File Storage Security to detect the drift of the deployed stack. |
| `cloudformation:DescribeStackResourceDrifts` | Action | Allow Cloud One File Storage Security to describe the drift of the deployed stack. |
| `cloudformation:GetStackPolicy` | Action | Allow Cloud One File Storage Security to get the stack policy. |
| `cloudformation:GetTemplate` | Action | Allow Cloud One File Storage Security to get the stack template. |
| `iam:GetRolePolicy` | Action | Allow Cloud One File Storage Security to get the management role policies. |
| `kms:Decrypt` | Action | **Optional.** Decrypt messages from encrypted `ScannerQueue` or Data key for scan result encryption. |
| `kms:GenerateDataKey` | Action | **Optional.** Generate a Data key to encrypt scan result messages sent to `ScanResultTopic` |
| `lambda:CreateAlias` | Action | Allow Cloud One File Storage Security to create an alias for Lambda functions created by Cloud One File Storage Security. |
| `lambda:DeleteAlias` | Action | Allow Cloud One File Storage Security to delete the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetAlias` | Action | Allow Cloud One File Storage Security to describe the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetEventSourceMapping` | Action | Allow Cloud One File Storage Security to describe the event source mapping of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunction` | Action | Allow Cloud One File Storage Security to describe the Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunctionConcurrency` | Action | Allow Cloud One File Storage Security to describe the concurrency configuration of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunctionConfiguration` | Action | Allow Cloud One File Storage Security to describe the configuration of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetLayerVersion` | Action | Allow Cloud One File Storage Security to describe the information of a version of the Lambda layers created or managed by Cloud One File Storage Security. |
| `lambda:GetProvisionedConcurrencyConfig` | Action | Allow Cloud One File Storage to describe the provisioned concurrency configuration of a Lambda function created by Cloud One File Storage Security. |
| `lambda:ListAliases` | Action | Allow Cloud One File Storage Security to list the aliases of Lambda functions created by Cloud One File Storage Security. |
| `lambda:ListProvisionedConcurrencyConfigs` | Action | Allow Cloud One File Storage Security to list the provisioned concurrency configurations of Lambda functions created by Cloud One File Storage Security. |
| `lambda:ListVersionsByFunction` | Action | Allow Cloud One File Storage Security to list the versions of the Lambda layers of Lambda functions by Cloud One File Storage Security. |
| `lambda:PublishVersion` | Action | Allow Cloud One File Storage Security to publish a new version of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateFunctionCode` | Action | Allow Cloud One File Storage Security to update the code of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateAlias` | Action | Allow Cloud One File Storage Security to update the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateFunctionConfiguration` | Action | Allow Cloud One File Storage Security to update the configuration of Lambda functions created by Cloud One File Storage Security. |
| `logs:DescribeLogStreams` | Action | Allow Cloud One File Storage Security to describe the log streams of the Lambda functions created by Cloud One File Storage Security. |
| `logs:GetLogEvents` | Action | Allow Cloud One File Storage Security to get the log events of the Lambda functions created by Cloud One File Storage Security. |
| `logs:StartQuery` | Action | Allow Cloud One File Storage Security to start a log query of the Lambda functions created by Cloud One File Storage Security. |
| `logs:StopQuery` | Action | Allow Cloud One File Storage Security to stop a log query of the Lambda functions created by Cloud One File Storage Security. |
| `logs:GetQueryResults` | Action | Allow Cloud One File Storage Security to get the log query results of the Lambda functions created by Cloud One File Storage Security. |
| `logs:FilterLogEvents` | Action | Allow Cloud One File Storage Security to filter the log events of the Lambda functions created by Cloud One File Storage Security. |
| `sns:Publish` | Action | Publish a message to an `ScanResultTopic`. |
| `sqs:ChangeMessageVisibility` | Action | Change the visibility timeout of messages in the `ScannerQueue`. |
| `sqs:DeleteMessage` | Action | Delete messages from the `ScannerQueue` and `ScannerDLQ`. |
| `sqs:GetQueueAttributes` | Action | Describe the attributes of the `ScannerQueue` and `ScannerDLQ` and allow Cloud One File Storage Security to get the attributes of the `ScannerQueue` and `ScannerDLQ`. |
| `sqs:ListDeadLetterSourceQueues` | Action | Allow Cloud One File Storage Security to list the `ScannerDLQ` source queues. |
| `sqs:ReceiveMessage` | Action | Receive messages from the `ScannerQueue` and `ScannerDLQ`. |
| `sqs:SetQueueAttributes` | Action | Allow Cloud One File Storage Security to set the attributes of the `ScannerQueue` and `ScannerDLQ`. |
| [AWSLambdaVPCAccessExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole$jsonEditor?) | Managed Policy | **Optional.** Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs. |
| `s3-object-lambda:WriteGetObjectResponse` | Action | **Optional.** Write the response of the GetObject API to the S3 Object Lambda. |

## Permissions required by storage stack

| Permission | Type | Description |
| --- | --- | --- |
| [AWSLambdaBasicExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole$jsonEditor) | Managed Policy | Provides write permissions for a Lambda function to CloudWatch Logs. |
| `cloudformation:DescribeStacks` | Action | Describe the stacks created by Cloud One File Storage Security. |
| `cloudformation:CreateChangeSet` | Action | Creates a list of changes that will be applied to a stack so that you can review the changes before executing them |
| `cloudformation:ListStackResources` | Action | Allow Cloud One File Storage Security to list the deployed resources. |
| `cloudformation:DescribeStacks` | Action | Allow Cloud One File Storage Security to describe the deployed stacks. |
| `cloudformation:DescribeStackEvents` | Action | Allow Cloud One File Storage Security to describe the stack events. |
| `cloudformation:DescribeStackResources` | Action | Allow Cloud One File Storage Security to describe the deployed resources. |
| `cloudformation:DescribeStackResource` | Action | Allow Cloud One File Storage Security to describe the deployed resources. |
| `cloudformation:DetectStackDrift` | Action | Allow Cloud One File Storage Security to detect the drift of the deployed stack. |
| `cloudformation:DetectStackResourceDrift` | Action | Allow Cloud One File Storage Security to detect the drift of the deployed stack. |
| `cloudformation:DescribeStackResourceDrifts` | Action | Allow Cloud One File Storage Security to describe the drift of the deployed stack. |
| `cloudformation:GetStackPolicy` | Action | Allow Cloud One File Storage Security to get the stack policy. |
| `cloudformation:GetTemplate` | Action | Allow Cloud One File Storage Security to get the stack template. |
| `iam:GetRolePolicy` | Action | Allow Cloud One File Storage Security to get the management role policies. |
| `kms:Decrypt` | Action | **Optional.** Decrypt the scanned objects, scan result, or Data key for scan message encryption. |
| `kms:GenerateDataKey` | Action | **Optional.** Generate a Data key to encrypt scan messages sent to the `ScannerQueue` |
| `lambda:CreateAlias` | Action | Allow Cloud One File Storage Security to create an alias for Lambda functions created by Cloud One File Storage Security. |
| `lambda:DeleteAlias` | Action | Allow Cloud One File Storage Security to delete the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetAlias` | Action | Allow Cloud One File Storage Security to describe the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetEventSourceMapping` | Action | Allow Cloud One File Storage Security to describe the event source mapping of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunction` | Action | Allow Cloud One File Storage Security to describe the Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunctionConcurrency` | Action | Allow Cloud One File Storage Security to describe the concurrency configuration of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetFunctionConfiguration` | Action | Allow Cloud One File Storage Security to describe the configuration of Lambda functions created by Cloud One File Storage Security. |
| `lambda:GetLayerVersion` | Action | Allow Cloud One File Storage Security to describe the information of a version of the Lambda layers created or managed by Cloud One File Storage Security. |
| `lambda:GetProvisionedConcurrencyConfig` | Action | Allow Cloud One File Storage to describe the provisioned concurrency configuration of a Lambda function created by Cloud One File Storage Security. |
| `lambda:ListAliases` | Action | Allow Cloud One File Storage Security to list the aliases of Lambda functions created by Cloud One File Storage Security. |
| `lambda:ListProvisionedConcurrencyConfigs` | Action | Allow Cloud One File Storage Security to list the provisioned concurrency configurations of Lambda functions created by Cloud One File Storage Security. |
| `lambda:ListVersionsByFunction` | Action | Allow Cloud One File Storage Security to list the versions of the Lambda layers of Lambda functions by Cloud One File Storage Security. |
| `lambda:PublishVersion` | Action | Allow Cloud One File Storage Security to publish a new version of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateFunctionCode` | Action | Allow Cloud One File Storage Security to update the code of the Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateAlias` | Action | Allow Cloud One File Storage Security to update the alias of Lambda functions created by Cloud One File Storage Security. |
| `lambda:UpdateFunctionConfiguration` | Action | Allow Cloud One File Storage Security to update the configuration of Lambda functions created by Cloud One File Storage Security. |
| `logs:DescribeLogStreams` | Action | Allow Cloud One File Storage Security to describe the log streams of the Lambda functions created by Cloud One File Storage Security. |
| `logs:GetLogEvents` | Action | Allow Cloud One File Storage Security to get the log events of the Lambda functions created by Cloud One File Storage Security. |
| `logs:StartQuery` | Action | Allow Cloud One File Storage Security to start a log query of the Lambda functions created by Cloud One File Storage Security. |
| `logs:StopQuery` | Action | Allow Cloud One File Storage Security to stop a log query of the Lambda functions created by Cloud One File Storage Security. |
| `logs:GetQueryResults` | Action | Allow Cloud One File Storage Security to get the log query results of the Lambda functions created by Cloud One File Storage Security. |
| `logs:FilterLogEvents` | Action | Allow Cloud One File Storage Security to filter the log events of the Lambda functions created by Cloud One File Storage Security. |
| `s3:GetBucketNotification` | Action | Allow Cloud One File Storage Security to get the notification configuration of the bucket to scan. |
| `s3:GetObject` | Action | Create pre-signed URL of the object to be scanned. |
| `s3:GetObjectTagging` | Action | List the tags of the scanned object. |
| `s3:ListBucket` | Action | List objects in an bucket. |
| `s3:PutBucketNotification` | Action | Allow Cloud One File Storage Security to enable notifications of specified events for a bucket. |
| `s3:PutObjectTagging` | Action | Put tags on the scanned object. |
| `sqs:SendMessage` | Action | Send scan messages to the `ScannerQueue`. |
| [AWSLambdaVPCAccessExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole$jsonEditor?) | Managed Policy | **Optional.** Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs. |
