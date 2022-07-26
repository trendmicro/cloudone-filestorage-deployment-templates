# Copyright (C) 2022 Trend Micro Inc. All rights reserved.
import role

resources = []
outputs = []

PATTERN_UPDATE_ROLE = 'trend-micro-fss-pattern-update-role'
GET_PATTERN_UPDATE_SCANNER_ROLE = 'trend-micro-fss-get-pattern-update-scanner-role'

roles = {
    PATTERN_UPDATE_ROLE: {
        'name': PATTERN_UPDATE_ROLE,
        'key': 'fssPatternUpdaterRoleID',
        'permissions': [
            'storage.objects.create',
            'storage.objects.delete',
            'storage.objects.get',
            'storage.objects.list',
            'storage.objects.update'
        ]
    },
    GET_PATTERN_UPDATE_SCANNER_ROLE: {
        'name': GET_PATTERN_UPDATE_SCANNER_ROLE,
        'key': 'fssPatternUpdateScannerRoleID',
        'permissions': [
            'storage.objects.get',
            'storage.objects.list',
        ]
    }
}

def generate_config(context):
    """ Entry point for the deployment resources. """

    return role.create_roles(roles.values())
