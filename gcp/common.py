# Copyright (C) 2022 Trend Micro Inc. All rights reserved.

def get_prefix(context, stack):
    prefix = context.env['deployment'].split(f'-{stack}')[0]
    return prefix[:22]
