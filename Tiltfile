docker_build(
    'tilt-avatar-api',
    context='.',
    dockerfile='./deploy/api.dockerfile',
    only=['api/'],
    live_update=[
        sync('./api/', '/app/api/'),
        sync('./api/requirements.txt', '/app/requirements.txt'),
        run('pip install -r /app/requirements.txt', trigger=['requirements.txt'])
    ]
)

k8s_yaml('deploy/api.yaml')

k8s_resource(
    'api',
    port_forwards='5734:5000',
    labels=['backend'],
)
