# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import role

CLOUD_FUNCTION_MANAGEMENT_ROLE = 'trend-micro-fss-cloud-function-management-role'
DEPLOYMENT_MANAGEMENT_ROLE = 'trend-micro-fss-deployment-management-role'
LOG_MANAGEMENT_ROLE = 'trend-micro-fss-log-management-role'
PUBSUB_IAM_MANAGEMENT_ROLE = 'trend-micro-fss-pubsub-iam-management-role'
PUBSUB_MANAGEMENT_ROLE = 'trend-micro-fss-pubsub-management-role'
SECRET_MANAGEMENT_ROLE = 'trend-micro-fss-secret-management-role'
SERVICE_ACCOUNT_MANAGEMENT_ROLE = 'trend-micro-fss-service-account-management-role'

roles = {
    CLOUD_FUNCTION_MANAGEMENT_ROLE: {
        'name': CLOUD_FUNCTION_MANAGEMENT_ROLE,
        'key': 'fssCloudFunctionManagementRoleID',
        'permissions': [
            'cloudfunctions.functions.get',
            'cloudfunctions.functions.list',
            'cloudfunctions.functions.sourceCodeGet',
            'cloudfunctions.functions.sourceCodeSet',
            'cloudfunctions.functions.update',
            'cloudbuild.builds.get',
            'cloudbuild.builds.list'
        ]
    },
    DEPLOYMENT_MANAGEMENT_ROLE: {
        'name': DEPLOYMENT_MANAGEMENT_ROLE,
        'key': 'fssDeploymentManagementRoleID',
        'permissions': [
            'deploymentmanager.deployments.get',
            'deploymentmanager.manifests.get'
        ]
    },
    LOG_MANAGEMENT_ROLE: {
        'name': LOG_MANAGEMENT_ROLE,
        'key': 'fssLogManagementRoleID',
        'permissions': [
            'logging.logs.list',
            'logging.queries.create',
            'logging.queries.get',
            'logging.queries.list',
        ]
    },
    PUBSUB_IAM_MANAGEMENT_ROLE: {
        'name': PUBSUB_IAM_MANAGEMENT_ROLE,
        'key': 'fssPubsubManagementRoleID',
        'permissions': [
            'pubsub.topics.getIamPolicy',
            'pubsub.topics.setIamPolicy',
        ]
    },
    PUBSUB_MANAGEMENT_ROLE: {
        'name': PUBSUB_MANAGEMENT_ROLE,
        'key': 'fssPubsubManagementRoleID',
        'permissions': [
            'pubsub.topics.get',
            'pubsub.topics.list',
            'pubsub.subscriptions.get',
            'pubsub.subscriptions.list',
        ]
    },
    SECRET_MANAGEMENT_ROLE: {
        'name': SECRET_MANAGEMENT_ROLE,
        'key': 'fssSecretManagementRoleID',
        'permissions': [
            'secretmanager.secrets.get',
            'secretmanager.versions.add',
            'secretmanager.versions.enable',
            'secretmanager.versions.destroy',
            'secretmanager.versions.disable',
            'secretmanager.versions.get',
            'secretmanager.versions.list',
            'secretmanager.versions.access',
        ]
    },
    SERVICE_ACCOUNT_MANAGEMENT_ROLE: {
        'name': SERVICE_ACCOUNT_MANAGEMENT_ROLE,
        'key': 'fssServiceAccountManagementRoleID',
        'permissions': [
            'iam.serviceAccounts.get',
            'iam.serviceAccounts.getIamPolicy',
            'iam.serviceAccounts.list',
        ]
    },
}

def generate_config(context):
    """ Entry point for the deployment resources. """

    return role.create_roles(roles.values())
