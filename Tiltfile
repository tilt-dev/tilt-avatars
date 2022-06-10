docker_build(
    'tilt-avatar-api',
    context='.',
    dockerfile='./deploy/api.dockerfile',
    only=['./api/'],
    live_update=[
        sync('./api/', '/app/api/'),
        run(
            'pip install -r /app/requirements.txt',
            trigger=['./api/requirements.txt']
        )
    ]
)

k8s_custom_deploy(
    'image-config',
    apply_cmd="kubectl create configmap image-config --from-literal=IMAGE=$TILT_IMAGE_0 -o=yaml --dry-run=client | kubectl apply -f - -o=yaml",
    delete_cmd="kubectl delete configmap image-config",
    deps=[],
    image_deps=['tilt-avatar-api'],
)
k8s_resource(
    'image-config',
    labels=['backend'],
    pod_readiness='ignore',
)

k8s_yaml('deploy/api.yaml')
k8s_resource(
    'api',
    port_forwards='5734:5000',
    labels=['backend']
)

docker_build(
    'tilt-avatar-web',
    context='.',
    dockerfile='./deploy/web.dockerfile',
    only=['./web/'],
    ignore=['./web/dist/'],
    live_update=[
        fall_back_on('./web/vite.config.js'),
        sync('./web/', '/app/'),
        run(
            'yarn install',
            trigger=['./web/package.json', './web/yarn.lock']
        )
    ]
)
k8s_yaml('deploy/web.yaml')
k8s_resource(
    'web',
    port_forwards='5735:3000',
    labels=['frontend']
)
