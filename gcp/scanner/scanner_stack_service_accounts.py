# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import common
import management_roles
import role

def create_service_account_resources(context):
    prefix = common.get_prefix(context, 'scanner')
    project_id = context.env['project']

    scanner_service_account = {
        'name': f'{prefix}-scanner-service-account',
        'type': 'gcp-types/iam-v1:projects.serviceAccounts',
        'properties': {
            'accountId': f'{prefix.lower()}-scan-sa',
            'displayName': 'Service Account for Scanner Cloud Function'
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
        scanner_service_account
    ]
    outputs = [
        {
            'name':  'scannerServiceAccountID',
            'value': scanner_service_account['properties']['accountId']
        },
        {
            'name': 'scannerProjectID',
            'value': project_id
        }
    ]
    return (resources, outputs)


def generate_config(context):
    """ Entry point for the deployment resources. """

    resources, outputs = create_service_account_resources(context)

    return {
        'resources': resources,
        'outputs': outputs
    }
