# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import common
import management_roles
import role

def create_scanner_stack_resources(context):
    prefix = common.get_prefix(context, 'scanner')

    properties = context.properties

    project_id = context.env['project']
    region = properties['region']
    management_service_account_id = properties['managementServiceAccountID']

    scanner_topic_name = f'{prefix}-scanner-topic'
    scanner_topic = {
        'name': scanner_topic_name,
        'type': 'pubsub.v1.topic',
        'properties': {
            'name': f"projects/{project_id}/topics/{scanner_topic_name}",
            'topic': scanner_topic_name
        },
        'accessControl': {
            'gcpIamPolicy': {
                'bindings': [
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.PUBSUB_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{management_service_account_id}"
                        ]
                    },
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.PUBSUB_IAM_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{management_service_account_id}"
                        ]
                    },
                    {
                        'role': 'roles/pubsub.publisher',
                        'members': [
                            f'serviceAccount:$(ref.{prefix}-scanner-service-account.email)',
                        ]
                    }
                ]
            }
        }
    }

    scanner = {
        'name': f'{prefix}-scanner',
        # https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions
        'type': 'gcp-types/cloudfunctions-v1:projects.locations.functions',
        'properties': {
            'parent': f'projects/{project_id}/locations/{region}',
            'function': f'{prefix}-scanner',
            'entryPoint': 'main',
            'sourceArchiveUrl': f"gs://{properties['artifactBucket']}/gcp-scanner.zip",
            'serviceAccountEmail': f'$(ref.{prefix}-scanner-service-account.email)',
            'runtime': 'python38',
            'availableMemoryMb': 2048,
            'timeout': '120s',
            'environmentVariables': {
                'LD_LIBRARY_PATH': '/workspace:/workspace/lib',
                'PATTERN_PATH': './patterns',
                'PROJECT_ID': project_id,
                'REGION': region,
                'DEPLOYMENT_NAME': properties['deploymentName']
            },
            'secretEnvironmentVariables': [
                {
                    'key': 'SCANNER_SECRETS',
                    'projectId': project_id,
                    'secret': f'{properties["scannerSecretsName"]}',
                    'version': 'latest'
                }
            ],
            'eventTrigger': {
                'eventType': 'providers/cloud.pubsub/eventTypes/topic.publish',
                'resource': f"projects/{project_id}/topics/{scanner_topic['name']}",
                'failurePolicy': {
                    'retry': {}
                }
            }
        },
        'metadata': {
            'dependsOn': [scanner_topic['name']]
        }
    }

    scanner_management_account_role_binding = {
        'name': 'scanner-management-account-role-binding',
        'type': 'gcp-types/cloudfunctions-v1:virtual.projects.locations.functions.iamMemberBinding',
        'properties': {
            'resource': f"$(ref.{scanner['name']}.name)",
            'role': role.get_role_name_ref(project_id, management_roles.CLOUD_FUNCTION_MANAGEMENT_ROLE),
            'member': f'serviceAccount:{management_service_account_id}'
        }
    }

    scanner_topic_dlt_name = f'{prefix}-scanner-topic-dlt'
    scanner_topic_dlt = {
        'name': scanner_topic_dlt_name,
        'type': 'pubsub.v1.topic',
        'properties': {
            'name': f"projects/{project_id}/topics/{scanner_topic_dlt_name}",
            'topic': scanner_topic_dlt_name
        },
        'accessControl': {
            'gcpIamPolicy': {
                'bindings': [
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.PUBSUB_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{management_service_account_id}"
                        ]
                    },
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.PUBSUB_IAM_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{management_service_account_id}"
                        ]
                    },
                    {
                        'role': 'roles/pubsub.publisher',
                        'members': [
                            f"serviceAccount:service-{context.env['project_number']}@gcp-sa-pubsub.iam.gserviceaccount.com",
                        ]
                    }
                ]
            }
        }
    }

    scanner_dlt = {
        'name': f'{prefix}-scanner-dlt',
        # https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions
        'type': 'gcp-types/cloudfunctions-v1:projects.locations.functions',
        'properties': {
            'parent': f'projects/{project_id}/locations/{region}',
            'function': f'{prefix}-scanner-dlt',
            'entryPoint': 'main',
            'sourceArchiveUrl': f"gs://{properties['artifactBucket']}/gcp-scanner-dlt.zip",
            'serviceAccountEmail': f'$(ref.{prefix}-scanner-service-account.email)',
            'runtime': 'python38',
            'eventTrigger': {
                'eventType': 'providers/cloud.pubsub/eventTypes/topic.publish',
                'resource': f"projects/{project_id}/topics/{scanner_topic_dlt['name']}",
            },
            'environmentVariables': {}
        },
        'metadata': {
            'dependsOn': [scanner_topic_dlt['name']]
        }
    }

    scanner_dlt_management_account_role_binding = {
        'name': 'scanner-dlt-management-account-role-binding',
        'type': 'gcp-types/cloudfunctions-v1:virtual.projects.locations.functions.iamMemberBinding',
        'properties': {
            'resource': f"$(ref.{scanner_dlt['name']}.name)",
            'role': role.get_role_name_ref(project_id, management_roles.CLOUD_FUNCTION_MANAGEMENT_ROLE),
            'member': f'serviceAccount:{management_service_account_id}'
        }
    }

    resources = [
        scanner,
        scanner_dlt,
        scanner_topic,
        scanner_topic_dlt,
        scanner_management_account_role_binding,
        scanner_dlt_management_account_role_binding
    ]
    outputs = [{
        'name': 'scannerTopic',
        'value': scanner_topic['name']
    },{
        'name': 'scannerTopicDLT',
        'value': scanner_topic_dlt['name']
    },{
        'name': 'scannerProjectID',
        'value': project_id
    },{
        'name': 'scannerFunctionName',
        'value': '$(ref.{}.name)'.format(scanner['name'])
    },{
        'name': 'scannerDLTFunctionName',
        'value': '$(ref.{}.name)'.format(scanner_dlt['name'])
    },{
        'name': 'region',
        'value': region
    },{
        'name': 'scannerSecretsName',
        'value': properties['scannerSecretsName']
    }]
    return (resources, outputs)


def generate_config(context):
    """ Entry point for the deployment resources. """

    resources, outputs = create_scanner_stack_resources(context)

    return {
        'resources': resources,
        'outputs': outputs
    }
