# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import common
import management_roles
import role
import storage_stack_roles

def create_service_account_resources(context):
    prefix = common.get_prefix(context, 'storage')
    project_id = context.env['project']

    bucket_listener_service_account = {
        'name': f'{prefix}-bucket-listener-service-account',
        'type': 'gcp-types/iam-v1:projects.serviceAccounts',
        'properties': {
            'accountId': f'{prefix.lower()}-bl-sa',
            'displayName': 'Service Account for Bucket Listener Cloud Function',
        },
        'accessControl': {
            'gcpIamPolicy': {
                'bindings': [
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.SERVICE_ACCOUNT_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{context.properties['managementServiceAccountID']}"
                        ]
                    },
                ]
            }
        }
    }

    binding_bucket_listener_role = {
        'name': 'bind-bucket-listener-iam-policy',
        'type': 'gcp-types/cloudresourcemanager-v1:virtual.projects.iamMemberBinding',
        'properties': {
            'resource': project_id,
            'role': role.get_role_name_ref(project_id, storage_stack_roles.BUCKET_LISTENER_ROLE),
            'member': f"serviceAccount:$(ref.{bucket_listener_service_account['name']}.email)"
        }
    }

    post_action_tag_service_account = {
        'name': f'{prefix}-post-action-tag-service-account',
        'type': 'gcp-types/iam-v1:projects.serviceAccounts',
        'properties': {
            'accountId': f'{prefix.lower()}-pat-sa',
            'displayName': 'Service Account for PostAction Tag Cloud Function',
        },
        'accessControl': {
            'gcpIamPolicy': {
                'bindings': [
                    {
                        'role': role.get_role_name_ref(project_id, management_roles.SERVICE_ACCOUNT_MANAGEMENT_ROLE),
                        'members': [
                            f"serviceAccount:{context.properties['managementServiceAccountID']}"
                        ]
                    },
                ]
            }
        }
    }

    resources = [
        bucket_listener_service_account,
        binding_bucket_listener_role,
        post_action_tag_service_account
    ]
    outputs = [{
        'name':  'bucketListenerServiceAccountID',
        'value': bucket_listener_service_account['properties']['accountId']
    },{
        'name':  'postActionTagServiceAccountID',
        'value': post_action_tag_service_account['properties']['accountId']
    }]
    return (resources, outputs)


def generate_config(context):
    """ Entry point for the deployment resources. """

    resources, outputs = create_service_account_resources(context)

    return {
        'resources': resources,
        'outputs': outputs
    }
