# Copyright (C) 2022 Trend Micro Inc. All rights reserved.

def get_role_name_ref(project_id, role_name):
    return f"projects/{project_id}/roles/{get_role_id(role_name)}"

def get_role_id(role_name):
    return role_name.lower().replace('-', '_')

def create_roles(roles):
    resources = []
    outputs = []

    for role_to_create in roles:
        created = create_role(role_to_create)
        resources.append(created['role'])
        outputs += created['outputs']

    return {
        'resources': resources,
        'outputs': outputs
    }

def create_role(role):
    role_id = get_role_id(role['name'])

    created = {
        'name': role['name'],
        'type': 'role.py',
        'properties': {
            'resourceName': role['name'],
            'title': role['name'].lower(),
            'roleID': role_id,
            'permissions': role['permissions'],
            'outputKey': role['key'],
        }
    }
    return {
        'role': created,
        'outputs': [{
            'name': role['key'],
            'value': role_id
        }]
    }

def create_role_resource(context):
    """ Creates the role resource. """

    project_id = context.env['project']

    properties = context.properties
    resource_name = properties['resourceName']
    role_id = properties['roleID']

    role = {
        'name': resource_name,
        'type': 'gcp-types/iam-v1:projects.roles',
        'properties': {
            'parent': f'projects/{project_id}',
            'roleId': role_id,
            'role':{
                'title': properties['title'],
                'description': f"Trend Micro File Storage Security {resource_name.replace('-', ' ').replace('_', ' ').replace('fss ', '')}",
                'stage': 'GA',
                'includedPermissions': properties['permissions']
            }
        }
    }

    return (
        [role],
        [{'name': properties['outputKey'], 'value': role_id}]
    )

def generate_config(context):
    """ Entry point for the deployment resources. """

    resources, outputs = create_role_resource(context)

    return {
        'resources': resources,
        'outputs': outputs
    }
