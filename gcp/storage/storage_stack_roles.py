# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import role

resources = []
outputs = []

BUCKET_LISTENER_ROLE = 'trend-micro-fss-bucket-listener-role'
POST_ACTION_TAG_ROLE = 'trend-micro-fss-post-action-tag-role'

roles = {
    BUCKET_LISTENER_ROLE: {
        'name': BUCKET_LISTENER_ROLE,
        'key': 'fssBucketListenerRoleID',
        'permissions': [
            'iam.serviceAccounts.signBlob'
        ]
    },
    POST_ACTION_TAG_ROLE: {
        'name': POST_ACTION_TAG_ROLE,
        'key': 'fssPostActionTagRoleID',
        'permissions': [
            'storage.objects.get',
            'storage.objects.update'
        ]
    }
}

def get_role(role_name):
    return roles[role_name]

def generate_config(context):
    """ Entry point for the deployment resources. """

    return role.create_roles(roles.values())
