# User permissions for deployment

Users need to have specific permissions to deploy, update, and delete. The file [deployment-role-policy.json](deployment-role-policy.json) and [deployment-role-policy-for-account-scanner.json](deployment-role-policy-for-account-scanner.json) contain the specific permissions that users need to deploy the CloudFormation templates. We recommend restricting roles to only the permissions required rather than a broad, permissive policy such as `AdministratorAccess`.

To add the policy:

- Go to `AWS account > IAM > Policies > Create policy`.

- Select `JSON` and copy and paste the whole content of the [deployment-role-policy.json](deployment-role-policy.json) file.

- Add `Tags` to the policy (optional), give a `Name` to the policy (Required) and a `Description` (Optional). Your policy is ready to be use.


To attach the policy to the user:

- Go to `IAM > Users` and select the user.
- Click `Add permissions`.
- Select `Attach existing policies directly`.
- Select the policy that you just created and click on `Next > Add permission`.


# Permissions required by the templates

The templates will create the required IAM roles and policies in order to work properly.
Also, the templates will create management roles for Cloud One File Storage Security to manage the deployed resources.
Check out the templates directly for more information.

> **Note:** It's not the permissions required to deploy the templates.

## FSS All-In-One

### Permissions required by scanner stack

| Permission | Type | Description |
| --- | --- | --- |
| [AWSLambdaBasicExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole$jsonEditor) | Managed Policy | Provides write permissions for a Lambda function to CloudWatch Logs |
| `cloudformation:DescribeStacks` | Action | Describes the stacks created by Cloud One File Storage Security |
| `cloudformation:CreateChangeSet` | Action | Creates a list of changes that will be applied to a stack so that you can review the changes before executing them |
| `cloudformation:ListStackResources` | Action | Allows Cloud One File Storage Security to list the deployed resources |
| `cloudformation:DescribeStacks` | Action | Allows Cloud One File Storage Security to describe the deployed stacks |
| `cloudformation:DescribeStackEvents` | Action | Allows Cloud One File Storage Security to describe the stack events |
| `cloudformation:DescribeStackResources` | Action | Allows Cloud One File Storage Security to describe the deployed resources |
| `cloudformation:DescribeStackResource` | Action | Allows Cloud One File Storage Security to describe the deployed resources |
| `cloudformation:DetectStackDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the deployed stack |
| `cloudformation:DetectStackResourceDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the deployed stack |
| `cloudformation:DescribeStackResourceDrifts` | Action | Allows Cloud One File Storage Security to describe the drift of the deployed stack |
| `cloudformation:GetStackPolicy` | Action | Allows Cloud One File Storage Security to get the stack policy |
| `cloudformation:GetTemplate` | Action | Allows Cloud One File Storage Security to get the stack template |
| `iam:GetRolePolicy` | Action | Allows Cloud One File Storage Security to get the management role policies |
| `kms:Decrypt` | Action | **Optional.** Decrypts messages from encrypted `ScannerQueue` or Data key for scan result encryption |
| `kms:GenerateDataKey` | Action | **Optional.** Generates a Data key to encrypt scan result messages sent to `ScanResultTopic` or scan messages sent to the `ScannerQueue` |
| `lambda:CreateAlias` | Action | Allows Cloud One File Storage Security to create an alias for Lambda functions created by Cloud One File Storage Security |
| `lambda:DeleteAlias` | Action | Allows Cloud One File Storage Security to delete the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetAlias` | Action | Allows Cloud One File Storage Security to describe the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetEventSourceMapping` | Action | Allows Cloud One File Storage Security to describe the event source mapping of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunction` | Action | Allows Cloud One File Storage Security to describe the Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunctionConcurrency` | Action | Allows Cloud One File Storage Security to describe the concurrency configuration of the Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunctionConfiguration` | Action | Allows Cloud One File Storage Security to describe the configuration of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetLayerVersion` | Action | Allows Cloud One File Storage Security to describe the information of a version of the Lambda layers created or managed by Cloud One File Storage Security |
| `lambda:GetProvisionedConcurrencyConfig` | Action | Allows Cloud One File Storage to describe the provisioned concurrency configuration of a Lambda function created by Cloud One File Storage Security |
| `lambda:ListAliases` | Action | Allows Cloud One File Storage Security to list the aliases of Lambda functions created by Cloud One File Storage Security |
| `lambda:ListProvisionedConcurrencyConfigs` | Action | Allows Cloud One File Storage Security to list the provisioned concurrency configurations of Lambda functions created by Cloud One File Storage Security |
| `lambda:ListVersionsByFunction` | Action | Allows Cloud One File Storage Security to list the versions of the Lambda layers of Lambda functions by Cloud One File Storage Security |
| `lambda:PublishVersion` | Action | Allows Cloud One File Storage Security to publish a new version of the Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateFunctionCode` | Action | Allows Cloud One File Storage Security to update the code of the Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateAlias` | Action | Allows Cloud One File Storage Security to update the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateFunctionConfiguration` | Action | Allows Cloud One File Storage Security to update the configuration of Lambda functions created by Cloud One File Storage Security |
| `logs:DescribeLogStreams` | Action | Allows Cloud One File Storage Security to describe the log streams of the Lambda functions created by Cloud One File Storage Security |
| `logs:GetLogEvents` | Action | Allows Cloud One File Storage Security to get the log events of the Lambda functions created by Cloud One File Storage Security |
| `logs:StartQuery` | Action | Allows Cloud One File Storage Security to start a log query of the Lambda functions created by Cloud One File Storage Security |
| `logs:StopQuery` | Action | Allows Cloud One File Storage Security to stop a log query of the Lambda functions created by Cloud One File Storage Security |
| `logs:GetQueryResults` | Action | Allows Cloud One File Storage Security to get the log query results of the Lambda functions created by Cloud One File Storage Security |
| `logs:FilterLogEvents` | Action | Allows Cloud One File Storage Security to filter the log events of the Lambda functions created by Cloud One File Storage Security |
| `sns:Publish` | Action | Publishes a message to an `ScanResultTopic` |
| `sqs:ChangeMessageVisibility` | Action | Changes the visibility timeout of messages in the `ScannerQueue` |
| `sqs:DeleteMessage` | Action | Deletes messages from the `ScannerQueue` and `ScannerDLQ` |
| `sqs:GetQueueAttributes` | Action | Describes the attributes of the `ScannerQueue` and `ScannerDLQ` and allow Cloud One File Storage Security to get the attributes of the `ScannerQueue` and `ScannerDLQ` |
| `sqs:ListDeadLetterSourceQueues` | Action | Allows Cloud One File Storage Security to list the `ScannerDLQ` source queues |
| `sqs:ReceiveMessage` | Action | Receives messages from the `ScannerQueue` and `ScannerDLQ` |
| `sqs:SendMessage` | Action | Sends messages to the `ScannerQueue` |
| `sqs:SetQueueAttributes` | Action | Allows Cloud One File Storage Security to set the attributes of the `ScannerQueue` and `ScannerDLQ` |
| [AWSLambdaVPCAccessExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole$jsonEditor?) | Managed Policy | **Optional.** Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs |
| `s3-object-lambda:WriteGetObjectResponse` | Action | **Optional.** Writes the response of the GetObject API to the S3 Object Lambda |

### Permissions required by storage stack

| Permission | Type | Description |
| --- | --- | --- |
| [AWSLambdaBasicExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole$jsonEditor) | Managed Policy | Provides write permissions for a Lambda function to CloudWatch Logs |
| `cloudformation:DescribeStacks` | Action | Describes the stacks created by Cloud One File Storage Security |
| `cloudformation:CreateChangeSet` | Action | Creates a list of changes that will be applied to a stack so that you can review the changes before executing them |
| `cloudformation:ListStackResources` | Action | Allows Cloud One File Storage Security to list the deployed resources |
| `cloudformation:DescribeStacks` | Action | Allows Cloud One File Storage Security to describe the deployed stacks |
| `cloudformation:DescribeStackEvents` | Action | Allows Cloud One File Storage Security to describe the stack events |
| `cloudformation:DescribeStackResources` | Action | Allows Cloud One File Storage Security to describe the deployed resources |
| `cloudformation:DescribeStackResource` | Action | Allows Cloud One File Storage Security to describe the deployed resources |
| `cloudformation:DetectStackDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the deployed stack |
| `cloudformation:DetectStackResourceDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the deployed stack |
| `cloudformation:DescribeStackResourceDrifts` | Action | Allows Cloud One File Storage Security to describe the drift of the deployed stack |
| `cloudformation:GetStackPolicy` | Action | Allows Cloud One File Storage Security to get the stack policy |
| `cloudformation:GetTemplate` | Action | Allows Cloud One File Storage Security to get the stack template |
| `iam:GetRolePolicy` | Action | Allows Cloud One File Storage Security to get the management role policies |
| `kms:Decrypt` | Action | **Optional.** Decrypts the scanned objects, scan result, or Data key for scan message encryption |
| `kms:GenerateDataKey` | Action | **Optional.** Generates a Data key to encrypt scan messages sent to the `ScannerQueue` |
| `lambda:CreateAlias` | Action | Allows Cloud One File Storage Security to create an alias for Lambda functions created by Cloud One File Storage Security |
| `lambda:DeleteAlias` | Action | Allows Cloud One File Storage Security to delete the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetAlias` | Action | Allows Cloud One File Storage Security to describe the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetEventSourceMapping` | Action | Allows Cloud One File Storage Security to describe the event source mapping of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunction` | Action | Allows Cloud One File Storage Security to describe the Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunctionConcurrency` | Action | Allows Cloud One File Storage Security to describe the concurrency configuration of the Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunctionConfiguration` | Action | Allows Cloud One File Storage Security to describe the configuration of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetLayerVersion` | Action | Allows Cloud One File Storage Security to describe the information of a version of the Lambda layers created or managed by Cloud One File Storage Security |
| `lambda:GetProvisionedConcurrencyConfig` | Action | Allows Cloud One File Storage to describe the provisioned concurrency configuration of a Lambda function created by Cloud One File Storage Security |
| `lambda:ListAliases` | Action | Allows Cloud One File Storage Security to list the aliases of Lambda functions created by Cloud One File Storage Security |
| `lambda:ListProvisionedConcurrencyConfigs` | Action | Allows Cloud One File Storage Security to list the provisioned concurrency configurations of Lambda functions created by Cloud One File Storage Security |
| `lambda:ListVersionsByFunction` | Action | Allows Cloud One File Storage Security to list the versions of the Lambda layers of Lambda functions by Cloud One File Storage Security |
| `lambda:PublishVersion` | Action | Allows Cloud One File Storage Security to publish a new version of the Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateFunctionCode` | Action | Allows Cloud One File Storage Security to update the code of the Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateAlias` | Action | Allows Cloud One File Storage Security to update the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateFunctionConfiguration` | Action | Allows Cloud One File Storage Security to update the configuration of Lambda functions created by Cloud One File Storage Security |
| `logs:DescribeLogStreams` | Action | Allows Cloud One File Storage Security to describe the log streams of the Lambda functions created by Cloud One File Storage Security |
| `logs:GetLogEvents` | Action | Allows Cloud One File Storage Security to get the log events of the Lambda functions created by Cloud One File Storage Security |
| `logs:StartQuery` | Action | Allows Cloud One File Storage Security to start a log query of the Lambda functions created by Cloud One File Storage Security |
| `logs:StopQuery` | Action | Allows Cloud One File Storage Security to stop a log query of the Lambda functions created by Cloud One File Storage Security |
| `logs:GetQueryResults` | Action | Allows Cloud One File Storage Security to get the log query results of the Lambda functions created by Cloud One File Storage Security |
| `logs:FilterLogEvents` | Action | Allows Cloud One File Storage Security to filter the log events of the Lambda functions created by Cloud One File Storage Security |
| `s3:GetBucketNotification` | Action | Allows Cloud One File Storage Security to get the notification configuration of the bucket to scan |
| `s3:GetObject` | Action | Creates pre-signed URL of the object to be scanned |
| `s3:GetObjectTagging` | Action | Lists the tags of the scanned object |
| `s3:ListBucket` | Action | Lists objects in an bucket |
| `s3:PutBucketNotification` | Action | Allows Cloud One File Storage Security to enable notifications of specified events for a bucket |
| `s3:PutObjectTagging` | Action | Puts tags on the scanned object |
| `sqs:SendMessage` | Action | Sends scan messages to the `ScannerQueue` |
| [AWSLambdaVPCAccessExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole$jsonEditor?) | Managed Policy | **Optional.** Provides minimum permissions for a Lambda function to execute while accessing a resource within a VPC - create, describe, delete network interfaces and write permissions to CloudWatch Logs |

## FSS Account Scanner Stack

### Permissions required by account scanner stack

> **Note:** The ManagementRole permissions that Cloud One File Storage Security uses to maintain the account scanner stack are in the section after this one.

| Permission | Type | Description |
| --- | --- | --- |
| [AWSLambdaBasicExecutionRole](https://console.aws.amazon.com/iam/home#/policies/arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole$jsonEditor) | Managed Policy | Provides write permissions for a Lambda function to CloudWatch Logs |
| `cloudformation:DescribeStacks` | Action | Describes the stacks created by Cloud One File Storage Security |
| `events:PutEvents` | Action | **Optional.** Puts events from different accounts to the EventBridge default event bus in the same account and region as the account scanner |
| `kms:Decrypt` | Action | **Optional.** Decrypts messages from encrypted `ScannerDLQ`, `PostScanActionDLQ`, s3 Bucket, or Data key for scan result encryption |
| `kms:GenerateDataKey` | Action | **Optional.** Generates a Data key used to encrypt the scan result messages sent to `ScanResultTopic` or the error messages sent to encrypted `ScannerDLQ` and `PostScanActionDLQ` |
| `lambda:CreateAlias` | Action | Creates an alias for Lambda functions created by Cloud One File Storage Security |
| `lambda:DeleteAlias` | Action | Deletes the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetFunctionConfiguration` | Action | Retrieves the configuration of Lambda functions created by Cloud One File Storage Security |
| `lambda:GetLayerVersion` | Action | Retrieves the information of a version of the Lambda layers created or managed by Cloud One File Storage Security |
| `lambda:InvokeFunction` | Action | Lets AWS service `EventBridge` and `SNS` invoke the Lambda functions created by Cloud One File Storage Security |
| `lambda:PublishVersion` | Action | Publishes a new version of the Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateAlias` | Action | Updates the alias of Lambda functions created by Cloud One File Storage Security |
| `lambda:UpdateFunctionConfiguration` | Action | Updates the configuration of Lambda functions created by Cloud One File Storage Security |
| `organizations:DescribeOrganization` | Action | Retrieves information about the organization that the current AWS account belongs to |
| `sns:Publish` | Action | Publishes a message to a `ScanResultTopic` created by Cloud One File Storage Security |
| `sqs:DeleteMessage` | Action | Deletes messages from the `ScannerDLQ` and `PostScanActionDLQ` created by Cloud One File Storage Security |
| `sqs:GetQueueAttributes` | Action | Gets the attributes of the `ScannerDLQ` and `PostScanActionDLQ` created by Cloud One File Storage Security |
| `sqs:ReceiveMessage` | Action | Receives messages from the `ScannerDLQ` and `PostScanActionDLQ` created by Cloud One File Storage Security |
| `sqs:SendMessage` | Action | Sends scan messages to the `ScannerDLQ` and `PostScanActionDLQ` created by Cloud One File Storage Security |
| `ssm:GetParameter` | Action | Retrieves values in AWS Systems Manager that Cloud One File Storage Security created |
| `sts:AssumeRole` | Action | Grants to different principals the permission to switch roles created by Cloud One File Storage Security |
| `s3:DeleteObject` | Action | Removes the malicious object from the scanning bucket after being quarantined |
| `s3:GetObject` | Action | Retrieves the object to be scanned or quarantined from Amazon S3 |
| `s3:GetObjectTagging` | Action | Lists the tags of the scanned object |
| `s3:PutObject` | Action | Puts the malicious object in the quarantine bucket |
| `s3:PutObjectTagging` | Action | Puts tags on the scanned object |

### Permissions required by ManagementRole

| Permission | Type | Description |
| --- | --- | --- |
| `cloudformation:CreateChangeSet` | Action | Allows Cloud One File Storage Security to create a list of changes that will be applied to a stack so that you can review the changes before executing them |
| `cloudformation:DescribeStacks` | Action | Allows Cloud One File Storage Security to describe the managed account scanner stack |
| `cloudformation:DescribeStackEvents` | Action | Allows Cloud One File Storage Security to describe the events in the managed account scanner stack |
| `cloudformation:DescribeStackResource` | Action | Allows Cloud One File Storage Security to describe the deployed resources in the managed account scanner stack |
| `cloudformation:DescribeStackResources` | Action | Allows Cloud One File Storage Security to describe the deployed resources in the managed account scanner stack |
| `cloudformation:DetectStackDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the managed account scanner stack |
| `cloudformation:DetectStackResourceDrift` | Action | Allows Cloud One File Storage Security to detect the drift of the deployed resources in the managed account scanner stack |
| `cloudformation:DescribeStackResourceDrifts` | Action | Allows Cloud One File Storage Security to describe the drift of the deployed resources in the managed account scanner stack |
| `cloudformation:GetStackPolicy` | Action | Allows Cloud One File Storage Security to get the managed account scanner stack policy |
| `cloudformation:GetTemplate` | Action | Allows Cloud One File Storage Security to get the template of the managed account scanner stack |
| `cloudformation:ListStackResources` | Action | Allows Cloud One File Storage Security to list the deployed resources in the managed account scanner stack |
| `iam:GetRolePolicy` | Action | Allows Cloud One File Storage Security to get the management role policies |
| `lambda:CreateAlias` | Action | Allows Cloud One File Storage Security to create an alias for Lambda functions in the managed account scanner stack |
| `lambda:DeleteAlias` | Action | Allows Cloud One File Storage Security to delete the alias of Lambda functions in the managed account scanner stack |
| `lambda:GetAlias` | Action | Allows Cloud One File Storage Security to describe the alias of Lambda functions in the managed account scanner stack |
| `lambda:GetEventSourceMapping` | Action | Allows Cloud One File Storage Security to describe the event source mapping of Lambda functions in the managed account scanner stack |
| `lambda:GetFunction` | Action | Allows Cloud One File Storage Security to describe the Lambda functions in the managed account scanner stack |
| `lambda:GetFunctionConcurrency` | Action | Allows Cloud One File Storage Security to describe the concurrency configuration of the Lambda functions in the managed account scanner stack |
| `lambda:GetFunctionConfiguration` | Action | Allows Cloud One File Storage Security to describe the configuration of Lambda functions in the managed account scanner stack |
| `lambda:GetLayerVersion` | Action | Allows Cloud One File Storage Security to describe the information of a version of the Lambda layers created or managed by Cloud One File Storage Security |
| `lambda:GetProvisionedConcurrencyConfig` | Action | Allows Cloud One File Storage to describe the provisioned concurrency configuration of a Lambda function in the managed account scanner stack |
| `lambda:ListAliases` | Action | Allows Cloud One File Storage Security to list the aliases of Lambda functions in the managed account scanner stack |
| `lambda:ListProvisionedConcurrencyConfigs` | Action | Allows Cloud One File Storage Security to list the provisioned concurrency configurations of Lambda functions in the managed account scanner stack |
| `lambda:ListVersionsByFunction` | Action | Allows Cloud One File Storage Security to list the versions of the Lambda layers of Lambda functions in the managed account scanner stack |
| `lambda:PublishVersion` | Action | Allows Cloud One File Storage Security to publish a new version of the Lambda functions in the managed account scanner stack |
| `lambda:UpdateFunctionCode` | Action | Allows Cloud One File Storage Security to update the code of the Lambda functions in the managed account scanner stack |
| `lambda:UpdateAlias` | Action | Allows Cloud One File Storage Security to update the alias of Lambda functions in the managed account scanner stack |
| `lambda:UpdateFunctionConfiguration` | Action | Allows Cloud One File Storage Security to update the configuration of Lambda functions in the managed account scanner stack |
| `logs:DescribeLogStreams` | Action | Allows Cloud One File Storage Security to describe the log streams of the Lambda functions in the managed account scanner stack |
| `logs:FilterLogEvents` | Action | Allows Cloud One File Storage Security to filter the log events of the Lambda functions in the managed account scanner stack |
| `logs:GetLogEvents` | Action | Allows Cloud One File Storage Security to get the log events of the Lambda functions in the managed account scanner stack |
| `logs:GetQueryResults` | Action | Allows Cloud One File Storage Security to get the log query results of the Lambda functions in the managed account scanner stack |
| `logs:StartQuery` | Action | Allows Cloud One File Storage Security to start a log query of the Lambda functions in the managed account scanner stack |
| `logs:StopQuery` | Action | Allows Cloud One File Storage Security to stop a log query of the Lambda functions in the managed account scanner stack |
| `sqs:GetQueueAttributes` | Action | Allows Cloud One File Storage Security to describe and get the attributes of the `ScannerDLQ` and `PostScanActionDLQ` in the managed account scanner stack |
| `sqs:ListDeadLetterSourceQueues` | Action | Allows Cloud One File Storage Security to list the source queues of `ScannerDLQ` and `PostScanActionDLQ` in the managed account scanner stack |
| `sqs:SetQueueAttributes` | Action | Allows Cloud One File Storage Security to set the attributes of the `ScannerDLQ` and `PostScanActionDLQ` in the managed account scanner stack |
| `ssm:GetParameter` | Action | Allows Cloud One File Storage Security to retrieve values about the managed account scanner stack in AWS Systems Manager that Cloud One File Storage Security created |
| `sts:AssumeRole` | Action | Allows Cloud One File Storage Security to grant the permissions to access this role to maintain the resources in the managed account scanner stack |
