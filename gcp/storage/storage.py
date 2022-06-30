# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import common
import management_roles
import role
import storage_stack_roles

def create_storage_stack_resources(context):
    prefix = common.get_prefix(context, 'storage')

    properties = context.properties

    project_id = context.env['project']
    region = properties['region']
    management_service_account_id = properties['managementServiceAccountID']

    scan_result_topic_name = f'{prefix}-scan-result-topic'
    scan_result_topic = {
        'name': scan_result_topic_name,
        'type': 'pubsub.v1.topic',
        'properties': {
            'name': f"projects/{project_id}/topics/{scan_result_topic_name}",
            'topic': scan_result_topic_name
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
                        'role': 'roles/pubsub.publisher',
                        'members': [
                            f'serviceAccount:$(ref.{prefix}-bucket-listener-service-account.email)',
                            f'serviceAccount:$(ref.{prefix}-post-action-tag-service-account.email)',
                            f"serviceAccount:{properties['scannerServiceAccountID']}@{properties['scannerProjectID']}.iam.gserviceaccount.com"
                        ]
                    }
                ]
            }
        }
    }

    bucket_listener = {
        'name': f'{prefix}-bucket-listener',
        # https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions
        'type': 'gcp-types/cloudfunctions-v1:projects.locations.functions',
        'properties': {
            'parent': f"projects/{project_id}/locations/{region}",
            'function': f'{prefix}-bucket-listener',
            'entryPoint': 'handler',
            'sourceArchiveUrl': f'gs://{properties["artifactBucket"]}/gcp-listener.zip',
            'serviceAccountEmail': f'$(ref.{prefix}-bucket-listener-service-account.email)',
            'runtime': 'nodejs16',
            'eventTrigger': {
                'eventType': 'google.storage.object.finalize',
                'resource': f"projects/{project_id}/buckets/{properties['scanningBucket']}",
            },
            'environmentVariables': {
                'SCANNER_PUBSUB_TOPIC': properties['scannerTopic'],
                'SCANNER_PROJECT_ID': properties['scannerProjectID'],
                'SCAN_RESULT_TOPIC': f'projects/{project_id}/topics/{scan_result_topic["name"]}',
                'DEPLOYMENT_NAME': properties['deploymentName'],
                'REPORT_OBJECT_KEY': properties['reportObjectKey']
            }
        }
    }

    bucket_listener_management_account_role_binding = {
        'name': 'bucket-listener-management-account-role-binding',
        'type': 'gcp-types/cloudfunctions-v1:virtual.projects.locations.functions.iamMemberBinding',
        'properties': {
            'resource': f"$(ref.{bucket_listener['name']}.name)",
            'role': role.get_role_name_ref(project_id, management_roles.CLOUD_FUNCTION_MANAGEMENT_ROLE),
            'member': f'serviceAccount:{management_service_account_id}'
        }
    }

    bucket_listener_service_account_binding = {
        'name': 'bucket-listener-service-account-binding',
        'type': 'gcp-types/storage-v1:virtual.buckets.iamMemberBinding',
        'properties': {
            'bucket': properties['scanningBucket'],
            'role': "roles/storage.legacyObjectReader",
            'member': f'serviceAccount:$(ref.{prefix}-bucket-listener-service-account.email)'
        }
    }

    post_action_tag = {
        'name': f'{prefix}-post-action-tag',
        # https://cloud.google.com/functions/docs/reference/rest/v1/projects.locations.functions
        'type': 'gcp-types/cloudfunctions-v1:projects.locations.functions',
        'properties': {
            'parent': f"projects/{project_id}/locations/{region}",
            'function': f'{prefix}-post-action-tag',
            'entryPoint': 'main',
            'sourceArchiveUrl': f'gs://{properties["artifactBucket"]}/gcp-action-tag.zip',
            'serviceAccountEmail': f'$(ref.{prefix}-post-action-tag-service-account.email)',
            'runtime': 'python38',
            'eventTrigger': {
                'eventType': 'providers/cloud.pubsub/eventTypes/topic.publish',
                'resource': f"projects/{project_id}/topics/{scan_result_topic['name']}",
                'failurePolicy': {
                    'retry': {}
                }
            }
        },
        'metadata': {
            'dependsOn': [scan_result_topic['name']]
        }
    }

    post_action_tag_management_account_role_binding = {
        'name': 'post-action-tag-management-account-role-binding',
        'type': 'gcp-types/cloudfunctions-v1:virtual.projects.locations.functions.iamMemberBinding',
        'properties': {
            'resource': f"$(ref.{post_action_tag['name']}.name)",
            'role': role.get_role_name_ref(project_id, management_roles.CLOUD_FUNCTION_MANAGEMENT_ROLE),
            'member': f'serviceAccount:{management_service_account_id}'
        }
    }

    post_action_tag_service_account_binding = {
        'name': 'post-action-tag-service-account-binding',
        'type': 'gcp-types/storage-v1:virtual.buckets.iamMemberBinding',
        'properties': {
            'bucket': properties['scanningBucket'],
            'role': role.get_role_name_ref(project_id, storage_stack_roles.POST_ACTION_TAG_ROLE),
            'member': f'serviceAccount:$(ref.{prefix}-post-action-tag-service-account.email)'
        }
    }

    resources = [
        bucket_listener,
        bucket_listener_management_account_role_binding,
        bucket_listener_service_account_binding,
        post_action_tag,
        post_action_tag_management_account_role_binding,
        post_action_tag_service_account_binding,
        scan_result_topic,
    ]
    outputs = [
        {
            'name': 'storageProjectID',
            'value': project_id
        },
        {
            'name': 'bucketListenerSourceArchiveUrl',
            'value': f'$(ref.{bucket_listener["name"]}.sourceArchiveUrl)'
        },
        {
            'name': 'scanResultTopic',
            'value': scan_result_topic["name"]
        },
        {
            'name': 'bucketListenerFunctionName',
            'value': '$(ref.{}.name)'.format(bucket_listener['name'])
        },
        {
            'name': 'postScanActionTagFunctionName',
            'value': '$(ref.{}.name)'.format(post_action_tag['name'])
        },
        {
            'name': 'region',
            'value': region
        },
        {
            'name': storage_stack_roles.get_role(storage_stack_roles.BUCKET_LISTENER_ROLE)['key'],
            'value': role.get_role_id(storage_stack_roles.BUCKET_LISTENER_ROLE)
        },
        {
            'name': storage_stack_roles.get_role(storage_stack_roles.POST_ACTION_TAG_ROLE)['key'],
            'value': role.get_role_id(storage_stack_roles.POST_ACTION_TAG_ROLE)
        }
    ]
    return (resources, outputs)

def generate_config(context):
    """ Entry point for the deployment resources. """

    (resources, outputs) = create_storage_stack_resources(context)

    return {
        'resources': resources,
        'outputs': outputs
    }
